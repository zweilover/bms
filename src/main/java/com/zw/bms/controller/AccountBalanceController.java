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
import com.zw.bms.commons.result.PageInfo;
import com.zw.bms.commons.utils.DateUtil;
import com.zw.bms.model.AccountBalance;
import com.zw.bms.service.IAccountBalanceService;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author zhaiwei
 * @since 2018-01-09
 */
@Controller
@RequestMapping("/accountBalance")
public class AccountBalanceController extends BaseController {

    @Autowired 
    private IAccountBalanceService accountBalanceService;
    
    @GetMapping("/manager")
    public String manager() {
        return "bi/accountBalance/accountBalanceList";
    }
    
    @PostMapping("/dataGrid")
    @ResponseBody
    public PageInfo dataGrid(AccountBalance accountBalance, Integer page, Integer rows, String sort,String order) {
        PageInfo pageInfo = new PageInfo(page, rows, sort, order);
        EntityWrapper<AccountBalance> ew = new EntityWrapper<AccountBalance>(accountBalance);
        Page<AccountBalance> pages = getPage(page, rows, sort, order);
        pages = accountBalanceService.selectPage(pages, ew);
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
        return "admin/accountBalance/accountBalanceAdd";
    }
    
    /**
     * 添加
     * @param 
     * @return
     */
    @PostMapping("/add")
    @ResponseBody
    public Object add(@Valid AccountBalance accountBalance) {
        accountBalance.setCreateTime(DateUtil.getNowDateTimeString());
        accountBalance.setUpdateTime(DateUtil.getNowDateTimeString());
        boolean b = accountBalanceService.insert(accountBalance);
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
        AccountBalance accountBalance = new AccountBalance();
        accountBalance.setId(id);
        accountBalance.setUpdateTime(DateUtil.getNowDateTimeString());
        boolean b = accountBalanceService.updateById(accountBalance);
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
        AccountBalance accountBalance = accountBalanceService.selectById(id);
        model.addAttribute("accountBalance", accountBalance);
        return "admin/accountBalance/accountBalanceEdit";
    }
    
    /**
     * 编辑
     * @param 
     * @return
     */
    @PostMapping("/edit")
    @ResponseBody
    public Object edit(@Valid AccountBalance accountBalance) {
        accountBalance.setUpdateTime(DateUtil.getNowDateTimeString());
        boolean b = accountBalanceService.updateById(accountBalance);
        if (b) {
            return renderSuccess("编辑成功！");
        } else {
            return renderError("编辑失败！");
        }
    }
}
