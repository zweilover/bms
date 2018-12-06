package com.zw.bms.controller;

import java.util.List;
import javax.validation.Valid;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.baomidou.mybatisplus.plugins.Page;
import com.zw.bms.commons.base.BaseController;
import com.zw.bms.commons.result.PageInfo;
import com.zw.bms.commons.utils.DateUtil;
import com.zw.bms.commons.utils.ShiroUtils;
import com.zw.bms.model.ChargeType;
import com.zw.bms.service.IChargeTypeService;

/**
 * <p>
 * 计费项目 前端控制器
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-18
 */
@Controller
@RequestMapping("/chargeType")
public class ChargeTypeController extends BaseController {

    @Autowired private IChargeTypeService chargeTypeService;
    
    @GetMapping("/manager")
    public String manager() {
        return "bi/chargeType/chargeTypeList";
    }
    
    /**
     * 计费项目列表查询
     * @param chargeType
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @return
     */
    @PostMapping("/dataGrid")
    @ResponseBody
    public PageInfo dataGrid(ChargeType chargeType, Integer page, Integer rows, String sort,String order) {
        PageInfo pageInfo = new PageInfo(page, rows, sort, order);
        Page<ChargeType> pages = getPage(page, rows, sort, order);
        if(StringUtils.isNotBlank(ShiroUtils.getShiroUser().getLocation())){
        	chargeType.setLocation(ShiroUtils.getShiroUser().getLocation());
        }
        pages.setRecords(chargeTypeService.selectChargeTypeList(pages, chargeType));
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
        return "bi/chargeType/chargeTypeAdd";
    }
    
    /**
     * 添加
     * @param 
     * @return
     */
    @PostMapping("/add")
    @ResponseBody
    public Object add(@Valid ChargeType chargeType) {
    	String currentDate = DateUtil.getNowDateTimeString();
        chargeType.setCreateTime(currentDate);
        chargeType.setUpdateTime(currentDate);
        chargeType.setCreateUser(ShiroUtils.getLoginName());
        chargeType.setUpdateUser(ShiroUtils.getLoginName());
        boolean b = chargeTypeService.insert(chargeType);
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
        ChargeType chargeType = new ChargeType();
        chargeType.setId(id);
        chargeType.setUpdateTime(DateUtil.getNowDateTimeString());
        chargeType.setUpdateUser(ShiroUtils.getLoginName());
        chargeType.setStatus("2");
        boolean b = chargeTypeService.updateById(chargeType);
        if (b) {
            return renderSuccess("删除成功！");
        } else {
            return renderError("删除失败！");
        }
    }
    
    /**
     * 编辑页面
     * @param model
     * @param id
     * @return
     */
    @GetMapping("/editPage")
    public String editPage(Model model, Long id) {
        ChargeType chargeType = chargeTypeService.selectById(id);
        model.addAttribute("chargeType", chargeType);
        return "bi/chargeType/chargeTypeEdit";
    }
    
    /**
     * 编辑
     * @param 
     * @return
     */
    @PostMapping("/edit")
    @ResponseBody
    public Object edit(@Valid ChargeType chargeType) {
        chargeType.setUpdateTime(DateUtil.getNowDateTimeString());
        chargeType.setUpdateUser(ShiroUtils.getLoginName());
        boolean b = chargeTypeService.updateById(chargeType);
        if (b) {
            return renderSuccess("编辑成功！");
        } else {
            return renderError("编辑失败！");
        }
    }
    
    /**
     * 打开设置计费子项页面
     * @param id
     * @param model
     * @return
     */
    @GetMapping("/grantPage")
    public String grantPage(Model model, Long id, String location) {
        model.addAttribute("id", id);
        model.addAttribute("location", location);
        return "bi/chargeType/chargeGrant";
    }
    
    /**
     * 查看计费子项页面
     * @param id
     * @param model
     * @return
     */
    @GetMapping("/viewItemsPage")
    public String viewItemsPage(Model model, Long id, String location) {
    	model.addAttribute("id", id);
    	model.addAttribute("location", location);
    	return "bi/chargeType/viewItems";
    }
    
    /**
     * 获取已设置的计费子项
     * @param id
     * @param resourceIds
     * @return
     */
    @RequestMapping("/findItemListByTypeId")
    @ResponseBody
    public Object findItemListByTypeId(Long id){
    	List<Long> itemIds = chargeTypeService.selectItemIdsListByTypeId(id);
    	return renderSuccess(itemIds);
    }
    
    /**
     * 设置计费子项
     * @param id
     * @param resourceIds
     * @return
     */
    @RequestMapping("/grant")
    @ResponseBody
    public Object grant(Long id, String itemIds){
    	chargeTypeService.updateChargeItemLink(id, itemIds);
    	ChargeType chargeType = new ChargeType();
    	chargeType.setId(id);
    	chargeType.setUpdateTime(DateUtil.getNowDateTimeString());
    	chargeType.setUpdateUser(ShiroUtils.getLoginName());
    	chargeTypeService.updateById(chargeType);
    	return renderSuccess("计费子项设置成功！");
    }
    
    /**
     * 获取所有计费项目，适用于下拉列表
     * @param isAllStatus 是否包含所有状态  
     * @return
     */
    @RequestMapping("/selectAllChargeType")
    @ResponseBody
    public Object selectAllType(@RequestParam boolean isAllStatus){
    	return chargeTypeService.selectAllType(isAllStatus);
    }

}
