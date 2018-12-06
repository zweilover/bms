package com.zw.bms.controller;

import javax.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.baomidou.mybatisplus.plugins.Page;
import com.zw.bms.commons.base.BaseController;
import com.zw.bms.commons.constants.ConstantsUtil;
import com.zw.bms.commons.result.PageInfo;
import com.zw.bms.commons.utils.DateUtil;
import com.zw.bms.commons.utils.ShiroUtils;
import com.zw.bms.model.AccountDetail;
import com.zw.bms.model.BigCustomer;
import com.zw.bms.service.IAccountDetailService;
import com.zw.bms.service.IBigCustomerService;

/**
 * <p>
 * 客户账户明细 前端控制器
 * </p>
 *
 * @author zhaiwei
 * @since 2018-01-16
 */
@Controller
@RequestMapping("/accountDetail")
public class AccountDetailController extends BaseController {

    @Autowired 
    private IAccountDetailService accountDetailService;
    
    @Autowired 
    private IBigCustomerService bigCustomerService;
    
    @GetMapping("/manager")
    public String manager() {
        return "bi/accountDetail/accountDetailList";
    }
    
    @PostMapping("/dataGrid")
    @ResponseBody
    public PageInfo dataGrid(AccountDetail accountDetail, Integer page, Integer rows, String sort,String order) {
        PageInfo pageInfo = new PageInfo(page, rows, sort, order);
        Page<AccountDetail> pages = getPage(page, rows, sort, order);
        pages.setRecords(accountDetailService.selectAccountDetailList(pages, accountDetail));
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
        return "bi/accountDetail/accountDetailAdd";
    }
    
    /**
     * 添加
     * @param 
     * @return
     */
    @PostMapping("/add")
    @ResponseBody
    public Object add(@Valid AccountDetail accountDetail) {
    	accountDetail.setStatus(ConstantsUtil.STATUS_NORMAL);
    	accountDetail.setCreateTime(DateUtil.getNowDateTimeString());
    	accountDetail.setUpdateTime(DateUtil.getNowDateTimeString());
    	accountDetail.setCreateUser(ShiroUtils.getLoginName());
    	accountDetail.setUpdateUser(ShiroUtils.getLoginName());
        boolean b = accountDetailService.insert(accountDetail);
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
        AccountDetail accountDetail = new AccountDetail();
        accountDetail.setId(id);
        accountDetail.setStatus(ConstantsUtil.STATUS_DELETE);
        accountDetail.setUpdateTime(DateUtil.getNowDateTimeString());
    	accountDetail.setUpdateUser(ShiroUtils.getLoginName());
        boolean b = accountDetailService.updateById(accountDetail);
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
        AccountDetail accountDetail = accountDetailService.selectById(id);
        BigCustomer cust = bigCustomerService.selectById(accountDetail.getCustomerId());
        accountDetail.setCustomerName(cust.getName());
        model.addAttribute("accountDetail", accountDetail);
        return "bi/accountDetail/accountDetailEdit";
    }
    
    /**
     * 编辑
     * @param 
     * @return
     */
    @PostMapping("/edit")
    @ResponseBody
    public Object edit(@Valid AccountDetail accountDetail) {
    	accountDetail.setUpdateTime(DateUtil.getNowDateTimeString());
    	accountDetail.setUpdateUser(ShiroUtils.getLoginName());
        boolean b = accountDetailService.updateById(accountDetail);
        if (b) {
            return renderSuccess("编辑成功！");
        } else {
            return renderError("编辑失败！");
        }
    }
    
    /**
     * 查看客户回款明细
     * @return
     */
    @RequestMapping("/viewReturnMoneyDetailList")
    public String viewReturnMoneyDetailList(Model model,Long customerId,String customerName,String paymentMonth) {
    	model.addAttribute("customerId", customerId);
    	model.addAttribute("customerName", customerName);
    	model.addAttribute("paymentMonth", paymentMonth);
    	return "bi/accountDetail/viewReturnMoneyDetailList";
    }
}
