package com.zw.bms.controller;

import java.util.List;

import javax.validation.Valid;

import org.apache.commons.lang.StringEscapeUtils;
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
import com.zw.bms.commons.result.PageInfo;
import com.zw.bms.commons.utils.DateUtil;
import com.zw.bms.commons.utils.ShiroUtils;
import com.zw.bms.commons.utils.StringUtils;
import com.zw.bms.model.ChargeItem;
import com.zw.bms.service.IChargeItemService;

/**
 * <p>
 * 计费子项 前端控制器
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-18
 */
@Controller
@RequestMapping("/chargeItem")
public class ChargeItemController extends BaseController {

    @Autowired private IChargeItemService chargeItemService;
    
    @GetMapping("/manager")
    public String manager() {
        return "bi/chargeItem/chargeItemList";
    }
    
    /**
     * 计费子项列表查询
     * @param chargeItem
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @return
     */
    @PostMapping("/dataGrid")
    @ResponseBody
    public PageInfo dataGrid(ChargeItem chargeItem, Integer page, Integer rows, String sort,String order) {
        PageInfo pageInfo = new PageInfo(page, rows, sort, order);
        Page<ChargeItem> pages = this.getPage(page, rows, sort, order);
        if(StringUtils.isNotBlank(ShiroUtils.getShiroUser().getLocation())){
        	chargeItem.setLocation(ShiroUtils.getShiroUser().getLocation());
        }
        pages.setRecords(chargeItemService.selectChargeItemList(pages, chargeItem));
        pageInfo.setRows(pages.getRecords());
        pageInfo.setTotal(pages.getTotal());
        return pageInfo;
    }
    
    /**
     * 查询所有的资源tree
     */
    @RequestMapping("/allItems")
    @ResponseBody
    public Object selectAllItems(String location){
    	EntityWrapper<ChargeItem> ew = new EntityWrapper<ChargeItem>();
    	ew.and("status = {0}", "0");
    	if(StringUtils.isNotBlank(location)){
    		ew.and("location = {0}", location);
    	}
    	ew.orderBy("seq");
    	return chargeItemService.selectList(ew);
    }
    
    /**
     * 添加页面
     * @return
     */
    @GetMapping("/addPage")
    public String addPage() {
        return "bi/chargeItem/chargeItemAdd";
    }
    
    /**
     * 添加
     * @param 
     * @return
     */
    @PostMapping("/add")
    @ResponseBody
    public Object add(@Valid ChargeItem chargeItem) {
    	String msg = chargeItemService.validData(chargeItem);
    	if(StringUtils.isNotBlank(msg)){
    		return renderError(msg);
    	}
    	if(StringUtils.isNotBlank(chargeItem.getScriptStr())){
    		chargeItem.setScriptStr(StringEscapeUtils.unescapeHtml(chargeItem.getScriptStr()) );
    	}
    	String currentDate = DateUtil.getNowDateTimeString();
        chargeItem.setCreateTime(currentDate);
        chargeItem.setUpdateTime(currentDate);
        chargeItem.setCreateUser(ShiroUtils.getLoginName());
        chargeItem.setUpdateUser(ShiroUtils.getLoginName());
        boolean b = chargeItemService.insert(chargeItem);
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
        ChargeItem chargeItem = new ChargeItem();
        chargeItem.setId(id);
        chargeItem.setStatus("2");//删除状态
        chargeItem.setUpdateTime(DateUtil.getNowDateTimeString());
        chargeItem.setUpdateUser(ShiroUtils.getLoginName());
        boolean b = chargeItemService.updateById(chargeItem);
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
        ChargeItem chargeItem = chargeItemService.selectById(id);
        model.addAttribute("chargeItem", chargeItem);
        return "bi/chargeItem/chargeItemEdit";
    }
    
    /**
     * 编辑
     * @param 
     * @return
     */
    @PostMapping("/edit")
    @ResponseBody
    public Object edit(@Valid ChargeItem chargeItem) {
    	String msg = chargeItemService.validData(chargeItem);
    	if(StringUtils.isNotBlank(msg)){
    		return renderError(msg);
    	}
    	if(StringUtils.isNotBlank(chargeItem.getScriptStr())){
    		chargeItem.setScriptStr(StringEscapeUtils.unescapeHtml(chargeItem.getScriptStr()) );
    	}
        chargeItem.setUpdateTime(DateUtil.getNowDateTimeString());
        chargeItem.setUpdateUser(ShiroUtils.getLoginName());
        boolean b = chargeItemService.updateById(chargeItem);
        if (b) {
            return renderSuccess("编辑成功！");
        } else {
            return renderError("编辑失败！");
        }
    }
    
    /**
     * 
     * @param typeId
     * @return
     */
    @PostMapping("/selectItemsByChargeType")
    @ResponseBody
    public List<ChargeItem> selectItemsByChargeType(Long typeId){
    	return chargeItemService.selectItemsByChargeType(typeId);
    }
}
