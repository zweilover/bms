package com.zw.bms.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.validation.Valid;
import org.apache.commons.lang.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.alibaba.fastjson.JSON;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.plugins.Page;
import com.zw.bms.commons.base.BaseController;
import com.zw.bms.commons.result.PageInfo;
import com.zw.bms.commons.utils.DateUtil;
import com.zw.bms.commons.utils.ShiroUtils;
import com.zw.bms.commons.utils.StringUtils;
import com.zw.bms.model.CarInfo;
import com.zw.bms.model.GoodsInfo;
import com.zw.bms.model.StoreDetail;
import com.zw.bms.model.StoreInfo;
import com.zw.bms.model.StoreStatement;
import com.zw.bms.service.IBigCustomerService;
import com.zw.bms.service.ICarInfoService;
import com.zw.bms.service.IGoodsInfoService;
import com.zw.bms.service.IStoreDetailService;
import com.zw.bms.service.IStoreInfoService;
import com.zw.bms.service.IStoreStatementService;

/**
 * <p>
 * 仓库信息表 前端控制器
 * </p>
 *
 * @author zhaiwei
 * @since 2018-08-31
 */
@Controller
@RequestMapping("/store")
public class StoreController extends BaseController {

    @Autowired 
    private IStoreInfoService storeInfoService;
    
    @Autowired 
    private IStoreStatementService storeStatementService;
    
    @Autowired 
    private IStoreDetailService storeDetailService;
    
    @Autowired 
    private ICarInfoService carInfoService;
    
    @Autowired 
    private IGoodsInfoService goodsInfoService;
    
    @Autowired 
    private IBigCustomerService custService;
    
    @RequestMapping("/storeInfoListPage")
    public String storeInfoListPage(Model model) {
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
        return "bi/store/storeInfoList";
    }
    
    @RequestMapping("/storeInfoList")
    @ResponseBody
    public PageInfo dataGrid(StoreInfo storeInfo, Integer page, Integer rows, String sort,String order) {
        PageInfo pageInfo = new PageInfo(page, rows, sort, order);
        storeInfo.setLocation(StringUtils.isNotBlank(storeInfo.getLocation()) ? storeInfo.getLocation() : ShiroUtils.getShiroUser().getLocation());
        EntityWrapper<StoreInfo> ew = new EntityWrapper<StoreInfo>();
        ew.and("status != {0}", "2");//去掉删除状态的数据
        if(StringUtils.isNotBlank(storeInfo.getName())){
        	ew.like("name", storeInfo.getName());
        }
        if(StringUtils.isNotBlank(storeInfo.getLocation())){
        	ew.eq("location",storeInfo.getLocation());
        }
        Page<StoreInfo> pages = getPage(page, rows, sort, order);
        pages = storeInfoService.selectPage(pages, ew);
        pageInfo.setRows(pages.getRecords());
        pageInfo.setTotal(pages.getTotal());
        return pageInfo;
    }
    
    /**
     * 添加页面
     * @return
     */
    @RequestMapping("/storeInfoAddPage")
    public String addStoreInfoPage(Model model) {
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
        return "bi/store/storeInfoAdd";
    }
    
    /**
     * 添加
     * @param 
     * @return
     */
    @RequestMapping("/storeInfoAdd")
    @ResponseBody
    public Object addStoreInfo(@Valid StoreInfo storeInfo) {
    	try{
    		storeInfoService.checkUnique4StoreInfo(storeInfo);
    	}catch(Exception e){
    		return renderError(e.getMessage());
    	}
    	
    	storeInfo.setCreateUser(ShiroUtils.getShiroUser().getLoginName());
    	storeInfo.setUpdateUser(ShiroUtils.getShiroUser().getLoginName());
    	storeInfo.setCreateTime(DateUtil.getNowDateTimeString());
    	storeInfo.setUpdateTime(DateUtil.getNowDateTimeString());
    	
        boolean b = storeInfoService.insert(storeInfo);
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
    @RequestMapping("/storeInfoDelete")
    @ResponseBody
    public Object deleteStoreInfo(Long id) {
        StoreInfo storeInfo = new StoreInfo();
        storeInfo.setId(id);
        storeInfo.setStatus("2");
        storeInfo.setUpdateUser(ShiroUtils.getShiroUser().getLoginName());
    	storeInfo.setUpdateTime(DateUtil.getNowDateTimeString());
        boolean b = storeInfoService.updateById(storeInfo);
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
    @RequestMapping("/storeInfoEditPage")
    public String editStoreInfoPage(Model model, Long id) {
        StoreInfo storeInfo = storeInfoService.selectById(id);
        model.addAttribute("storeInfo", storeInfo);
        model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
        return "bi/store/storeInfoEdit";
    }
    
    /**
     * 编辑
     * @param 
     * @return
     */
    @RequestMapping("/storeInfoEdit")
    @ResponseBody
    public Object editStoreInfo(@Valid StoreInfo storeInfo) {
    	try{
    		storeInfoService.checkUnique4StoreInfo(storeInfo);
    	}catch(Exception e){
    		return renderError(e.getMessage());
    	}
    	storeInfo.setUpdateUser(ShiroUtils.getShiroUser().getLoginName());
    	storeInfo.setUpdateTime(DateUtil.getNowDateTimeString());
        boolean b = storeInfoService.updateById(storeInfo);
        if (b) {
            return renderSuccess("编辑成功！");
        } else {
            return renderError("编辑失败！");
        }
    }
    
    /**
     * 库存管理列表
     * @param model
     * @return
     */
    @RequestMapping("/storeManageListPage")
    public String storeManageListPage(Model model) {
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
        return "bi/store/storeManageList";
    }
    
    /**
     * 获取库房管理列表
     * @param storeInfo
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @return
     */
    @RequestMapping("/storeManageList")
    @ResponseBody
    public PageInfo storeManageList(StoreInfo storeInfo, Integer page, Integer rows, String sort,String order,
    		@RequestParam(value = "carNo",required=false) String carNo,
    		@RequestParam(value = "cardNo",required=false) String cardNo,
    		@RequestParam(value = "location",required=false) String location,
    		@RequestParam(value = "carStatus",required=false) String carStatus,
    		@RequestParam(value = "inTimeStart",required=false) String inTimeStart,
    		@RequestParam(value = "inTimeEnd",required=false) String inTimeEnd,
    		@RequestParam(value = "outTimeStart",required=false) String outTimeStart,
    		@RequestParam(value = "outTimeEnd",required=false) String outTimeEnd,
    		@RequestParam(value = "goodsInTimeStart",required=false) String goodsInTimeStart,
    		@RequestParam(value = "goodsInTimeEnd",required=false) String goodsInTimeEnd,
    		@RequestParam(value = "goodsOutTimeStart",required=false) String goodsOutTimeStart,
    		@RequestParam(value = "goodsOutTimeEnd",required=false) String goodsOutTimeEnd) {
        PageInfo pageInfo = new PageInfo(page, rows, sort, order);
        Page<HashMap<String,Object>> pages = getPage(page, rows, sort, order);
        storeInfo.setLocation(StringUtils.isNotBlank(storeInfo.getLocation()) ? storeInfo.getLocation() : ShiroUtils.getShiroUser().getLocation());
        Map<String,Object> queryParam = new HashMap<String,Object>();
        queryParam.put("location", storeInfo.getLocation());
        queryParam.put("carNo", carNo);
        queryParam.put("carStatus", carStatus);
        queryParam.put("cardNo", cardNo);
        queryParam.put("inTimeStart", inTimeStart);
        queryParam.put("inTimeEnd", DateUtil.getDayAfter(inTimeEnd));
        queryParam.put("outTimeStart", outTimeStart);
        queryParam.put("outTimeEnd", DateUtil.getDayAfter(outTimeEnd));
        queryParam.put("goodsInTimeStart", goodsInTimeStart);
        queryParam.put("goodsInTimeEnd", DateUtil.getDayAfter(goodsInTimeEnd));
        queryParam.put("goodsOutTimeStart", goodsOutTimeStart);
        queryParam.put("goodsOutTimeEnd", DateUtil.getDayAfter(goodsOutTimeEnd));
        pages.setRecords(storeStatementService.getStoreManageList(pages, queryParam));
        pageInfo.setRows(pages.getRecords());
        pageInfo.setTotal(pages.getTotal());
        return pageInfo;
    }
    
    /**
     * 车辆出入库管理页面
     * @return
     */
    @RequestMapping("/storeManageAdd4CarPage")
    public String storeInAdd4CarPage(Model model,
    		@RequestParam(value = "carId",required=false) String carId,
    		@RequestParam(value = "type",required=false) String type) {
    	if(StringUtils.isNotBlank(carId)){
    		CarInfo carInfo = carInfoService.selectById(carId);
    		model.addAttribute("carInfo", carInfo);
    		model.addAttribute("customer", custService.selectById(carInfo.getCustomerId()));
    	}
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
    	model.addAttribute("type",type);//1:出库 2:入库
        return "bi/store/storeManageAdd4Car";
    }
    
    /**
     * 无车出入库页面
     * @return
     */
    @RequestMapping("/storeManageAddNoCarPage")
    public String storeInAddNoCarPage(Model model,
    		@RequestParam(value = "type",required=false) String type) {
    	model.addAttribute("type",type);//1:出库 2:入库
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
        return "bi/store/storeManageAddNoCar";
    }

    /**
     * 出入库编辑页面
     * @return
     */
    @RequestMapping("/storeManageEditPage")
    public String storeManageEditPage(Model model,Long stId) {
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
    	StoreStatement storeStatement = storeStatementService.selectById(stId);
    	model.addAttribute("statement", storeStatement);
    	model.addAttribute("customer", custService.selectById(storeStatement.getCustomerId()));
        return "bi/store/storeManageEdit";
    }
    
    /**
     * 出入库查看页面
     * @return
     */
    @RequestMapping("/storeManageViewPage")
    public String storeManageViewPage(Model model,Long stId) {
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
    	StoreStatement storeStatement = storeStatementService.selectById(stId);
    	model.addAttribute("statement", storeStatement);
    	model.addAttribute("customer", custService.selectById(storeStatement.getCustomerId()));
    	return "bi/store/storeManageView";
    }
    
    /**
     * 出入库保存
     * @param 
     * @return
     */
    @RequestMapping("/storeManageSave")
    @ResponseBody
    public Object storeManageSave(@Valid StoreStatement storeStatement,
    		@RequestParam(value = "storeDetail",required=false) String storeDetail) {
    	try{
    		List<StoreDetail> storeDetailList = JSON.parseArray(StringEscapeUtils.unescapeHtml(storeDetail),StoreDetail.class);
    		storeStatementService.saveStoreStateAndDetail(storeStatement,storeDetailList);
    		return renderSuccess("保存成功！");
    	}catch(Exception e){
    		return renderError("保存失败！"+e.getMessage());
    	}
    }

    /**
     * 出入库明细编辑页面
     * @return
     */
    @RequestMapping("/storeDetailAddPage")
    public String storeDetailAddPage(Model model,
    		@RequestParam(value = "carId",required=false) String carId,
    		@RequestParam(value = "carNo",required=false) String carNo,
    		@RequestParam(value = "cardNo",required=false) String cardNo) {
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
    	model.addAttribute("carId", carId);
    	model.addAttribute("carNo", carNo);
    	model.addAttribute("cardNo", cardNo);
        return "bi/store/storeDetailAddPage";
    }
    
    @RequestMapping("/getStoreDetailByStateId")
    @ResponseBody
    public Object getStoreDetailByStateId(@RequestParam(value = "stId",required=false) Long stId) {
    	StoreDetail detail = new StoreDetail();
    	detail.setStatementId(stId);
    	EntityWrapper<StoreDetail> ew = new EntityWrapper<StoreDetail>(detail);
        return storeDetailService.selectList(ew);
    }
    
    /**
     * 商品
     * @param model
     * @return
     */
    @RequestMapping("/goodsInfoListPage")
    public String goodsInfoListPage(Model model) {
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
        return "bi/store/goodsInfoList";
    }
    
    @RequestMapping("/goodsInfoList")
    @ResponseBody
    public PageInfo goodsInfoList(GoodsInfo goodsInfo, Integer page, Integer rows, String sort,String order) {
        PageInfo pageInfo = new PageInfo(page, rows, sort, order);
        goodsInfo.setLocation(StringUtils.isNotBlank(goodsInfo.getLocation()) ? goodsInfo.getLocation() : ShiroUtils.getShiroUser().getLocation());
        EntityWrapper<GoodsInfo> ew = new EntityWrapper<GoodsInfo>();
        ew.and("status != {0}", "2");//去掉删除状态的数据
        if(StringUtils.isNotBlank(goodsInfo.getName())){
        	ew.like("name", goodsInfo.getName());
        }
        if(StringUtils.isNotBlank(goodsInfo.getLocation())){
        	ew.eq("location",goodsInfo.getLocation());
        }
        Page<GoodsInfo> pages = getPage(page, rows, sort, order);
        pages = goodsInfoService.selectPage(pages, ew);
        pageInfo.setRows(pages.getRecords());
        pageInfo.setTotal(pages.getTotal());
        return pageInfo;
    }
    
    /**
     * 添加页面
     * @return
     */
    @RequestMapping("/goodsInfoAddPage")
    public String goodsInfoAddPage(Model model) {
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
        return "bi/store/goodsInfoAdd";
    }
    
    /**
     * 添加
     * @param 
     * @return
     */
    @RequestMapping("/goodsInfoAdd")
    @ResponseBody
    public Object goodsInfoAdd(@Valid GoodsInfo goodsInfo) {
    	try{
    		goodsInfoService.checkUnique4GoodsInfo(goodsInfo);
    	}catch(Exception e){
    		return renderError(e.getMessage());
    	}
    	
    	goodsInfo.setCreateUser(ShiroUtils.getShiroUser().getLoginName());
    	goodsInfo.setUpdateUser(ShiroUtils.getShiroUser().getLoginName());
    	goodsInfo.setCreateTime(DateUtil.getNowDateTimeString());
    	goodsInfo.setUpdateTime(DateUtil.getNowDateTimeString());
    	
        boolean b = goodsInfoService.insert(goodsInfo);
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
    @RequestMapping("/goodsInfoDelete")
    @ResponseBody
    public Object deleteGoodsInfo(Long id) {
        GoodsInfo goodsInfo = new GoodsInfo();
        goodsInfo.setId(id);
        goodsInfo.setStatus("2");
        goodsInfo.setUpdateUser(ShiroUtils.getShiroUser().getLoginName());
        goodsInfo.setUpdateTime(DateUtil.getNowDateTimeString());
        boolean b = goodsInfoService.updateById(goodsInfo);
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
    @RequestMapping("/goodsInfoEditPage")
    public String editGoodsInfoPage(Model model, Long id) {
        GoodsInfo goodsInfo = goodsInfoService.selectById(id);
        model.addAttribute("goodsInfo", goodsInfo);
        model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
        return "bi/store/goodsInfoEdit";
    }
    
    /**
     * 编辑
     * @param 
     * @return
     */
    @RequestMapping("/goodsInfoEdit")
    @ResponseBody
    public Object editGoodsInfo(@Valid GoodsInfo goodsInfo) {
    	try{
    		goodsInfoService.checkUnique4GoodsInfo(goodsInfo);
    	}catch(Exception e){
    		return renderError(e.getMessage());
    	}
    	
    	goodsInfo.setUpdateUser(ShiroUtils.getShiroUser().getLoginName());
    	goodsInfo.setUpdateTime(DateUtil.getNowDateTimeString());
        boolean b = goodsInfoService.updateById(goodsInfo);
        if (b) {
            return renderSuccess("编辑成功！");
        } else {
            return renderError("编辑失败！");
        }
    }
    
    /**
     * 获取所有库房列表，适用于下拉列表
     * @param location 所属区域
     * @return
     */
    @RequestMapping("/selectAllStoreInfoList")
    @ResponseBody
    public Object selectAllStoreInfoList(@RequestParam(value = "location",required=false) String location,
    		@RequestParam(value = "isAllStatus",required=false) Boolean isAllStatus){
    	 EntityWrapper<StoreInfo> ew = new EntityWrapper<StoreInfo>();
         if(StringUtils.isNotBlank(location)){
         	ew.eq("location",location);
         }
         if(null == isAllStatus || isAllStatus != true){
        	 ew.and("status = {0}", "0");//只获取正常状态的数据
         }
         ew.orderBy("seq,name", true);
    	return storeInfoService.selectList(ew);
    }
    
    /**
     * 获取所有货物列表，适用于下拉列表
     * @param isAllStatus 是否包含所有状态
     * @return
     */
    @RequestMapping("/selectAllGoodsInfoList")
    @ResponseBody
    public Object selectAllGoodsInfoList(@RequestParam(value = "location",required=false) String location,
    		@RequestParam(value = "isAllStatus",required=false) Boolean isAllStatus){
    	 EntityWrapper<GoodsInfo> ew = new EntityWrapper<GoodsInfo>();
         if(StringUtils.isNotBlank(location)){
         	ew.eq("location",location);
         }
         if(null == isAllStatus || isAllStatus != true){
        	 ew.and("status = {0}", "0");//只获取正常状态的数据
         }
         ew.orderBy("seq,name", true);
    	return goodsInfoService.selectList(ew);
    }
}
