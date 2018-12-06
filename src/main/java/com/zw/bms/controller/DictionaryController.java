package com.zw.bms.controller;

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
import com.zw.bms.commons.base.BaseController;
import com.zw.bms.commons.utils.DateUtil;
import com.zw.bms.commons.utils.ShiroUtils;
import com.zw.bms.model.Dictionary;
import com.zw.bms.service.IDictionaryService;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-10
 */
@Controller
@RequestMapping("/dictionary")
public class DictionaryController extends BaseController {

    @Autowired 
    private IDictionaryService dictionaryService;
    
    @GetMapping("/manager")
    public String manager() {
        return "admin/dictionary/dictionaryList";
    }
    
    @PostMapping("/treeGrid")
    @ResponseBody
    public Object treeGrid(Dictionary di) {
    	return dictionaryService.selectAll(di);
    }
    
    /**
     * 下拉选择
     * @return
     */
    @PostMapping("/tree")
    @ResponseBody
    public Object tree() {
    	return dictionaryService.selectTree();
    }
    
    /**
     * 根据字典code返回所有子项
     * @param code
     * @return
     */
    @PostMapping("/selectDiByCode")
    @ResponseBody
    public Object selectByCode(@RequestParam String code){
    	return dictionaryService.selectDictionaryByCode(code);
    }
    
    /**
     * 添加页面
     * @return
     */
    @GetMapping("/addPage")
    public String addPage() {
        return "admin/dictionary/dictionaryAdd";
    }
    
    /**
     * 添加
     * @param 
     * @return
     */
    @PostMapping("/add")
    @ResponseBody
    public Object add(@Valid Dictionary dictionary) {
    	String msg = dictionaryService.validData(dictionary);
    	if(!StringUtils.isEmpty(msg)){
    		return renderError(msg);
    	}
    	String currentTime = DateUtil.getNowDateTimeString();
    	dictionary.setCode(StringUtils.isNotBlank(dictionary.getCode()) ? dictionary.getCode().toUpperCase() : "");
    	dictionary.setCreateTime(currentTime);
    	dictionary.setUpdateTime(currentTime);
    	dictionary.setCreateUser(ShiroUtils.getLoginName());
    	dictionary.setUpdateUser(ShiroUtils.getLoginName());
        boolean b = dictionaryService.insert(dictionary);
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
    	Dictionary dictionary = new Dictionary();
    	dictionary.setId(id);
    	dictionary.setStatus("2");
    	dictionary.setUpdateTime(DateUtil.getNowDateTimeString());
    	dictionary.setUpdateUser(ShiroUtils.getLoginName());
        boolean b = dictionaryService.updateById(dictionary);
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
        Dictionary dictionary = dictionaryService.selectById(id);
        model.addAttribute("dictionary", dictionary);
        return "admin/dictionary/dictionaryEdit";
    }
    
    /**
     * 编辑
     * @param 
     * @return
     */
    @PostMapping("/edit")
    @ResponseBody
    public Object edit(@Valid Dictionary dictionary) {
    	String msg = dictionaryService.validData(dictionary);
    	if(StringUtils.isNotBlank(msg)){
    		return renderError(msg);
    	}
    	dictionary.setCode(StringUtils.isNotBlank(dictionary.getCode()) ? dictionary.getCode().toUpperCase() : "");
        dictionary.setUpdateTime(DateUtil.getNowDateTimeString());
        dictionary.setUpdateUser(ShiroUtils.getLoginName());
    	boolean b = dictionaryService.updateById(dictionary);
        if (b) {
            return renderSuccess("修改成功！");
        } else {
            return renderError("修改失败！");
        }
    }
}
