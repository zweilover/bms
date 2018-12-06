package com.zw.bms.controller;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.plugins.Page;
import com.zw.bms.commons.base.BaseController;
import com.zw.bms.commons.constants.ConstantsUtil;
import com.zw.bms.commons.result.PageInfo;
import com.zw.bms.commons.utils.DateUtil;
import com.zw.bms.commons.utils.ShiroUtils;
import com.zw.bms.commons.utils.StringUtils;
import com.zw.bms.model.CardLink;
import com.zw.bms.service.ICardLinkService;

/**
 * <p>
 * 运通卡关联表 前端控制器
 * </p>
 *
 * @author zhaiwei
 * @since 2018-08-01
 */
@Controller
@RequestMapping("/cardLink")
public class CardLinkController extends BaseController {

    @Autowired 
    private ICardLinkService cardLinkService;
    
    @GetMapping("/manager")
    public String manager() {
        return "bi/cardLink/cardLinkList";
    }
    
    @PostMapping("/dataGrid")
    @ResponseBody
    public PageInfo dataGrid(CardLink cardLink, Integer page, Integer rows, String sort,String order) {
        PageInfo pageInfo = new PageInfo(page, rows, sort, order);
        EntityWrapper<CardLink> ew = new EntityWrapper<CardLink>();
        ew.addFilter(" status = 0 ");//正常状态
        if(StringUtils.isNotBlank(cardLink.getCarNo())){//车号
        	ew.addFilter(" car_no like {0}", "%" + cardLink.getCarNo().toUpperCase() + "%");
        }
        if(StringUtils.isNotBlank(cardLink.getCardNo())){//运通卡号
        	ew.addFilter(" card_no = {0}", cardLink.getCardNo());
        }
        Page<CardLink> pages = getPage(page, rows, sort, order);
        pages = cardLinkService.selectPage(pages, ew);
        pageInfo.setRows(pages.getRecords());
        pageInfo.setTotal(pages.getTotal());
        return pageInfo;
    }
    
    /**
     * 添加页面
     * @return
     */
    @GetMapping("/addPage")
    public String addPage() {
        return "bi/cardLink/cardLinkAdd";
    }
    
    /**
     * 添加
     * @param 
     * @return
     */
    @PostMapping("/add")
    @ResponseBody
    public Object add(@Valid CardLink cardLink) {
    	try{
    		cardLinkService.checkUnique4CardNo(cardLink);
    	}catch(Exception e){
    		return renderError(e.getMessage());
    	}
    	cardLink.setCarNo(StringUtils.isNotBlank(cardLink.getCarNo()) ? cardLink.getCarNo().toUpperCase() : "" );
    	cardLink.setCreateTime(DateUtil.getNowDateTimeString());
    	cardLink.setCreateUser(ShiroUtils.getLoginName());
    	cardLink.setUpdateTime(DateUtil.getNowDateTimeString());
    	cardLink.setUpdateUser(ShiroUtils.getLoginName());
    	cardLink.setStatus(ConstantsUtil.STATUS_NORMAL);
        boolean b = cardLinkService.insert(cardLink);
        if (b) {
            return renderSuccess("添加成功！");
        } else {
            return renderError("添加失败！");
        }
    }
    
    /**
     * 删除
     * @param id
     * @return
     */
    @PostMapping("/delete")
    @ResponseBody
    public Object delete(Long id) {
        CardLink cardLink = new CardLink();
        cardLink.setId(id);
        cardLink.setUpdateTime(DateUtil.getNowDateTimeString());
    	cardLink.setUpdateUser(ShiroUtils.getLoginName());
        cardLink.setStatus("1");
        boolean b = cardLinkService.updateById(cardLink);
        if (b) {
            return renderSuccess("删除成功！");
        } else {
            return renderError("删除失败！");
        }
    }
    
    /**
     * 编辑
     * @param model
     * @param id
     * @return
     */
    @GetMapping("/editPage")
    public String editPage(Model model, Long id) {
        CardLink cardLink = cardLinkService.selectById(id);
        model.addAttribute("cardLink", cardLink);
        return "bi/cardLink/cardLinkEdit";
    }
    
    /**
     * 编辑
     * @param 
     * @return
     */
    @PostMapping("/edit")
    @ResponseBody
    public Object edit(@Valid CardLink cardLink) {
    	try{
    		cardLinkService.checkUnique4CardNo(cardLink);
    	}catch(Exception e){
    		return renderError(e.getMessage());
    	}
    	cardLink.setCarNo(StringUtils.isNotBlank(cardLink.getCarNo()) ? cardLink.getCarNo().toUpperCase() : "" );
    	cardLink.setUpdateTime(DateUtil.getNowDateTimeString());
    	cardLink.setUpdateUser(ShiroUtils.getLoginName());
        boolean b = cardLinkService.updateById(cardLink);
        if (b) {
            return renderSuccess("编辑成功！");
        } else {
            return renderError("编辑失败！");
        }
    }
    
    /**
     * 根据运通卡号获取运通卡关联信息
     * @param cardNo
     * @return
     */
    @RequestMapping("/getCardLinkByCardNo")
    @ResponseBody
    public Object getCardLinkByCardNo(CardLink cardLink){
    	cardLink.setStatus(ConstantsUtil.STATUS_NORMAL);
    	EntityWrapper<CardLink> ew = new EntityWrapper<CardLink>(cardLink);
    	CardLink reCardLink = cardLinkService.selectOne(ew);
    	if(null != reCardLink){
    		return renderSuccess(reCardLink);
    	}else{
    		return renderError("未获取到数据！");
    	}
    	
    }
}
