package com.zw.bms.controller;

import javax.validation.Valid;
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
import com.zw.bms.commons.constants.ConstantsUtil;
import com.zw.bms.commons.result.PageInfo;
import com.zw.bms.commons.utils.DateUtil;
import com.zw.bms.commons.utils.ShiroUtils;
import com.zw.bms.commons.utils.StringUtils;
import com.zw.bms.model.BigCustomer;
import com.zw.bms.model.CustomerItem;
import com.zw.bms.service.IBigCustomerService;
import com.zw.bms.service.ICustomerItemService;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-30
 */
@Controller
@RequestMapping("/bigCustomer")
public class BigCustomerController extends BaseController {

    @Autowired 
    private IBigCustomerService bigCustomerService;
    
    @Autowired 
    private ICustomerItemService customerItemService;
    
    @GetMapping("/manager")
    public String manager() {
        return "bi/bigCustomer/bigCustomerList";
    }
    
    @PostMapping("/dataGrid")
    @ResponseBody
    public PageInfo dataGrid(BigCustomer bigCustomer, Integer page, Integer rows, String sort,String order) {
        PageInfo pageInfo = new PageInfo(page, rows, sort, order);
        Page<BigCustomer> pages = getPage(page, rows, sort, order);
        pages.setRecords(bigCustomerService.selectBigCustomerList(pages, bigCustomer));
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
        return "bi/bigCustomer/bigCustomerAdd";
    }
    
    /**
     * 添加
     * @param 
     * @return
     */
    @PostMapping("/add")
    @ResponseBody
    public Object add(@Valid BigCustomer bigCustomer) {
    	//数据校验
    	String msg = bigCustomerService.validData(bigCustomer);
    	if(StringUtils.isNotBlank(msg)){
    		return renderError(msg);
    	}
        bigCustomer.setCreateTime(DateUtil.getNowDateTimeString());
        bigCustomer.setUpdateTime(DateUtil.getNowDateTimeString());
        bigCustomer.setCreateUser(ShiroUtils.getLoginName());
        bigCustomer.setUpdateUser(ShiroUtils.getLoginName());
        boolean b = bigCustomerService.insert(bigCustomer);
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
        BigCustomer bigCustomer = new BigCustomer();
        bigCustomer.setId(id);
        bigCustomer.setStatus(ConstantsUtil.STATUS_DELETE);
        bigCustomer.setUpdateTime(DateUtil.getNowDateTimeString());
        bigCustomer.setUpdateUser(ShiroUtils.getLoginName());
        boolean b = bigCustomerService.updateById(bigCustomer);
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
        BigCustomer bigCustomer = bigCustomerService.selectById(id);
        model.addAttribute("bigCustomer", bigCustomer);
        return "bi/bigCustomer/bigCustomerEdit";
    }
    
    /**
     * 编辑
     * @param 
     * @return
     */
    @PostMapping("/edit")
    @ResponseBody
    public Object edit(@Valid BigCustomer bigCustomer) {
    	//数据校验
    	String msg = bigCustomerService.validData(bigCustomer);
    	if(StringUtils.isNotBlank(msg)){
    		return renderError(msg);
    	}
        bigCustomer.setUpdateTime(DateUtil.getNowDateTimeString());
        bigCustomer.setUpdateUser(ShiroUtils.getLoginName());
        boolean b = bigCustomerService.updateById(bigCustomer);
        if (b) {
            return renderSuccess("编辑成功！");
        } else {
            return renderError("编辑失败！");
        }
    }
    
    /**
     * 根据客户id获取计费子项
     * @param bigCustomer
     * @return
     */
    @PostMapping("/getCustItemsByCustomerId")
    @ResponseBody
    public Object getCustItemsByCustomerId(@RequestParam Long customerId){
    	return bigCustomerService.getCustItemsByCustomerId(customerId);
    }
    
    /**
     * 添加计费子项页面
     * @return
     */
    @GetMapping("/addCustItemPage")
    public String addCustItemPage(Model model, Long customerId) {
    	BigCustomer bigCustomer = bigCustomerService.selectById(customerId);
        model.addAttribute("bigCustomer", bigCustomer);
        return "bi/bigCustomer/customerItemAdd";
    }
    
    /**
     * 添加计费子项
     * @param 
     * @return
     */
    @PostMapping("/addCustItem")
    @ResponseBody
    public Object addCustItem(@Valid CustomerItem customerItem) {
    	//数据校验
    	String msg = bigCustomerService.validItemData(customerItem);
    	if(StringUtils.isNotBlank(msg)){
    		return renderError(msg);
    	}
    	customerItem.setCreateTime(DateUtil.getNowDateTimeString());
    	customerItem.setUpdateTime(DateUtil.getNowDateTimeString());
    	customerItem.setCreateUser(ShiroUtils.getLoginName());
    	customerItem.setUpdateUser(ShiroUtils.getLoginName());
        boolean b = customerItemService.insert(customerItem);
        if (b) {
            return renderSuccess("添加成功！");
        } else {
            return renderError("添加失败！");
        }
    }
    
    /**
     * 编辑计费子项页面
     * @param model
     * @param id
     * @return
     */
    @GetMapping("/editCustItemPage")
    public String editCustItemPage(Model model, Long id) {
        CustomerItem customerItem = customerItemService.selectById(id);
        model.addAttribute("customerItem", customerItem);
        BigCustomer bigCustomer = bigCustomerService.selectById(customerItem.getCustomerId());
        model.addAttribute("bigCustomer", bigCustomer);
        return "bi/bigCustomer/customerItemEdit";
    }
    
    /**
     * 编辑计费子项
     * @param 
     * @return
     */
    @PostMapping("/editCustItem")
    @ResponseBody
    public Object editCustItem(@Valid CustomerItem customerItem) {
    	//数据校验
    	String msg = bigCustomerService.validItemData(customerItem);
    	if(StringUtils.isNotBlank(msg)){
    		return renderError(msg);
    	}
    	customerItem.setUpdateTime(DateUtil.getNowDateTimeString());
    	customerItem.setUpdateUser(ShiroUtils.getLoginName());
        boolean b = customerItemService.updateById(customerItem);
        if (b) {
            return renderSuccess("编辑成功！");
        } else {
            return renderError("编辑失败！");
        }
    }
    
    /**
     * 删除计费子项
     * @param id
     * @return
     */
    @PostMapping("/deleteCustItem")
    @ResponseBody
    public Object deleteCustItem(Long id) {
        CustomerItem customerItem = new CustomerItem();
        customerItem.setId(id);
        customerItem.setStatus(ConstantsUtil.STATUS_DELETE);
        customerItem.setUpdateTime(DateUtil.getNowDateTimeString());
        customerItem.setUpdateUser(ShiroUtils.getLoginName());
        boolean b = customerItemService.updateById(customerItem);
        if (b) {
            return renderSuccess("删除成功！");
        } else {
            return renderError("删除失败！");
        }
    }
    
    /**
     * 获取所有大客户，适用于下拉列表
     * @param isAllStatus 是否包含所有状态
     * @return
     */
    @PostMapping("/selectAllCustomer")
    @ResponseBody
    public Object selectAllCustomer(@RequestParam boolean isAllStatus){
    	return bigCustomerService.selectAllCustomer(isAllStatus);
    }
    
    /**
     * 选择大客户页面，适用于弹出页面
     * @return
     */
    @GetMapping("/selectCustomerPage")
    public String selectBigCustomer() {
        return "bi/bigCustomer/selectCustomer";
    }
}
