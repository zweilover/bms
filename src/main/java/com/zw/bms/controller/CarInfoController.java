package com.zw.bms.controller;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.apache.commons.lang.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
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
import com.zw.bms.model.CardLink;
import com.zw.bms.model.ChargeType;
import com.zw.bms.model.ManualNetHistory;
import com.zw.bms.model.PaymentDetail;
import com.zw.bms.model.StoreStatement;
import com.zw.bms.service.IBigCustomerService;
import com.zw.bms.service.ICarInfoService;
import com.zw.bms.service.ICardLinkService;
import com.zw.bms.service.IChargeTypeService;
import com.zw.bms.service.IManualNetHistoryService;
import com.zw.bms.service.IStoreStatementService;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-28
 */
@Controller
@RequestMapping("/carInfo")
public class CarInfoController extends BaseController {

    @Autowired 
    private ICarInfoService carInfoService;
    
    @Autowired 
    private ICardLinkService cardLinkService;
    
    @Autowired 
    private IChargeTypeService chargeTypeService;
    
    @Autowired
    private IManualNetHistoryService manualNetHistoryService;
    
    @Autowired 
    private IStoreStatementService storeStatementService;
    
    @Autowired 
    private IBigCustomerService bigCustomerService;
    
    @GetMapping("/manager")
    public String manager(Model model) {
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
        return "bi/carInfo/carInfoList";
    }
    
    @PostMapping("/dataGrid")
    @ResponseBody
    public PageInfo dataGrid(CarInfo carInfo, Integer page, Integer rows, String sort,String order) {
        PageInfo pageInfo = new PageInfo(page, rows, sort, order);
        Page<CarInfo> pages = getPage(page, rows, sort, order);
        if(StringUtils.isBlank(carInfo.getLocation())){
        	carInfo.setLocation(ShiroUtils.getShiroUser().getLocation());
        }
        pages.setRecords(carInfoService.selectCarInfoList(pages, carInfo));
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
        return "bi/carInfo/carInfoAdd";
    }
    
    /**
     * 添加
     * @param 
     * @return
     */
    @PostMapping("/add")
    @ResponseBody
    public Object add(@Valid CarInfo carInfo,String isChange,String cardLinkId) {
    	try{
    		carInfoService.checkUnique4CardInfo(carInfo);
    	}catch(Exception e){
    		return renderError(e.getMessage());
    	}
    	
    	carInfo.setCarNo(StringUtils.isNotBlank(carInfo.getCarNo()) ? carInfo.getCarNo().toUpperCase() : "");
    	String currentTime = DateUtil.getNowDateTimeString();
        carInfo.setCreateTime(currentTime);
        carInfo.setUpdateTime(currentTime);
        carInfo.setInTime(currentTime);
        carInfo.setInUser(ShiroUtils.getLoginName());
        carInfo.setCreateUser(ShiroUtils.getLoginName());
        carInfo.setUpdateUser(ShiroUtils.getLoginName());
        carInfo.setCarStatus("0");
        carInfo.setLocation(ShiroUtils.getShiroUser().getLocation());
        boolean b = carInfoService.insert(carInfo);
        
        //更新运通卡关联信息
        if(StringUtils.isNotBlank(isChange) && "1".equals(isChange)){
    		CardLink cardLink = null;
    		if(StringUtils.isNotBlank(cardLinkId)){
    			cardLink = cardLinkService.selectById(cardLinkId);
    			cardLink.setCarNo(carInfo.getCarNo());
    			cardLink.setUpdateTime(currentTime);
    			cardLink.setUpdateUser(ShiroUtils.getLoginName());
    			cardLinkService.updateById(cardLink);
    		}else{
    			cardLink = new CardLink();
    			cardLink.setCardNo(carInfo.getCardNo());
    			cardLink.setCarNo(carInfo.getCarNo());
    			cardLink.setStatus("0");
    			cardLink.setCreateTime(currentTime);
    			cardLink.setCreateUser(ShiroUtils.getLoginName());
    			cardLink.setUpdateTime(currentTime);
    			cardLink.setUpdateUser(ShiroUtils.getLoginName());
    			cardLinkService.insert(cardLink);
    		}
    	}
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
    	CarInfo car = carInfoService.selectById(id);
    	if(null != car && !"0".equals(car.getCarStatus())){
    		return renderError("该车辆状态不允许删除！");
    	}
    	
        CarInfo carInfo = new CarInfo();
        carInfo.setId(id);
        carInfo.setUpdateTime(DateUtil.getNowDateTimeString());
        carInfo.setUpdateUser(ShiroUtils.getLoginName());
        carInfo.setCarStatus("2");
        boolean b = carInfoService.updateById(carInfo);
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
        CarInfo carInfo = carInfoService.selectById(id);
        model.addAttribute("carInfo", carInfo);
        if(null != carInfo && StringUtils.isNotBlank(carInfo.getCardNo())){
        	CardLink cardLinkPara = new CardLink();
        	cardLinkPara.setCardNo(carInfo.getCardNo());
        	cardLinkPara.setStatus("0");
        	EntityWrapper<CardLink> ew = new EntityWrapper<CardLink>(cardLinkPara);
        	CardLink cardLink = cardLinkService.selectOne(ew);
        	model.addAttribute("cardLink", cardLink);
        }
        return "bi/carInfo/carInfoEdit";
    }
    
    /**
     * 编辑
     * @param 
     * @return
     */
    @PostMapping("/edit")
    @ResponseBody
    public Object edit(@Valid CarInfo carInfo,String isChange,String cardLinkId) {
    	try{
    		carInfoService.checkUnique4CardInfo(carInfo);
    	}catch(Exception e){
    		return renderError(e.getMessage());
    	}
    	
    	carInfo.setCarNo(StringUtils.isNotBlank(carInfo.getCarNo()) ? carInfo.getCarNo().toUpperCase() : "");
        carInfo.setUpdateTime(DateUtil.getNowDateTimeString());
        carInfo.setUpdateUser(ShiroUtils.getLoginName());
        boolean b = carInfoService.updateById(carInfo);
        
        //更新运通卡关联信息
        if(StringUtils.isNotBlank(isChange) && "1".equals(isChange)){
    		CardLink cardLink = null;
    		if(StringUtils.isNotBlank(cardLinkId)){
    			cardLink = cardLinkService.selectById(cardLinkId);
    			cardLink.setCarNo(carInfo.getCarNo());
    			cardLink.setUpdateTime(DateUtil.getNowDateTimeString());
    			cardLink.setUpdateUser(ShiroUtils.getLoginName());
    			cardLinkService.updateById(cardLink);
    		}else{
    			cardLink = new CardLink();
    			cardLink.setCardNo(carInfo.getCardNo());
    			cardLink.setCarNo(carInfo.getCarNo());
    			cardLink.setStatus("0");
    			cardLink.setCreateTime(DateUtil.getNowDateTimeString());
    			cardLink.setCreateUser(ShiroUtils.getLoginName());
    			cardLink.setUpdateTime(DateUtil.getNowDateTimeString());
    			cardLink.setUpdateUser(ShiroUtils.getLoginName());
    			cardLinkService.insert(cardLink);
    		}
    	}
        
        if (b) {
            return renderSuccess("编辑成功！");
        } else {
            return renderError("编辑失败！");
        }
    }
    
    /**
     * 管理员编辑页面
     * @param model
     * @param id
     * @return
     */
    @GetMapping("/carSysEditPage")
    public String carSysEditPage(Model model, Long id) {
        CarInfo carInfo = carInfoService.getCarInfoDetail(id);
        model.addAttribute("carInfo", carInfo);
        return "bi/carInfo/carSysEdit";
    }
    
    /**
     * 管理员编辑
     * @param 
     * @return
     */
    @PostMapping("/carSysEdit")
    @ResponseBody
    public Object carSysEdit(@Valid CarInfo carInfo) {
    	carInfo.setCarNo(StringUtils.isNotBlank(carInfo.getCarNo()) ? carInfo.getCarNo().toUpperCase() : "");
        carInfo.setUpdateTime(DateUtil.getNowDateTimeString());
        carInfo.setUpdateUser(ShiroUtils.getLoginName());
        boolean b = carInfoService.updateById(carInfo);
        if (b) {
            return renderSuccess("修改成功！");
        } else {
            return renderError("修改失败！");
        }
    }
    
    /**
     * 查看出库账单详情
     * @param model
     * @param id
     * @return
     */
    @GetMapping("/viewCarOutPayPage")
    public String viewCarOutPayPage(Model model, Long id) {
        CarInfo carInfo = carInfoService.getCarInfoDetail(id);
        model.addAttribute("carInfo", carInfo);
        return "bi/carInfo/carOutPaymenView";
    }
    
    /**
     * 根据车辆id获取付款明细
     * @param 
     * @return
     */
    @PostMapping("/getPaymentDetailByCarId")
    @ResponseBody
    public Object getPaymentDetailByCarId(Long id) {
    	List<PaymentDetail> lst_detail = null;
    	try{
    		lst_detail = carInfoService.getPaymentDetailByCarId(id);
    	}catch(Exception e){
    		e.printStackTrace();
    	}
    	return lst_detail;
    }
    
    @GetMapping("/outManager")
    public String outManager(Model model) {
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
        return "bi/carInfo/carOutList";
    }
    
    /**
     * 出库收费页面
     * @param model
     * @param id
     * @return
     */
    @GetMapping("/paymentPage")
    public String paymentPage(Model model, Long id) {
        CarInfo carInfo = carInfoService.selectById(id);
        carInfo.setOutTime(DateUtil.getNowDateTimeString());
        model.addAttribute("carInfo", carInfo);
        if(null != carInfo && null != carInfo.getManualNetweight() && carInfo.getManualNetweight() > 0){
        	model.addAttribute("netWeight",Math.floor(carInfo.getManualNetweight()));//向下取整
        }
        EntityWrapper<StoreStatement> ew = new EntityWrapper<StoreStatement>();
        ew.and("type = {0}","1");//出库状态
        ew.and("car_id = {0}",carInfo.getId());
        StoreStatement state = storeStatementService.selectOne(ew);
        if(null != state && state.getId() > 0){
        	model.addAttribute("state",state);
        	model.addAttribute("cust",bigCustomerService.selectById(state.getCustomerId()));
        }
        return "bi/carInfo/carOutPayment";
    }
    
    /**
     * 运抵费页面
     * @param model
     * @param id
     * @return
     */
    @GetMapping("/charge4YundiPage")
    public String carCharge4YundiPage(Model model, Long id) {
        CarInfo carInfo = carInfoService.selectById(id);
        carInfo.setOutTime(DateUtil.getNowDateTimeString());
        model.addAttribute("carInfo", carInfo);
        return "bi/carInfo/carCharge4Yundi";
    }
    
    /**
     * 计算付款明细
     * @param 
     * @return
     */
    @PostMapping("/genPaymentDetail")
    @ResponseBody
    public Object calPaymentDetail(@Valid CarInfo carInfo,HttpServletRequest request) {
    	List<PaymentDetail> lst_detail = null;
    	try{
    		lst_detail = carInfoService.genPaymentDetail(carInfo);
    	}catch(Exception e){
    		e.printStackTrace();
    	}
    	return lst_detail;
    }
    
    /**
     * 出库付款
     * @param 
     * @return
     */
    @PostMapping("/dealPayment")
    @ResponseBody
    public Object dealPayment(@Valid CarInfo carInfo,@RequestParam("type") String type,HttpServletRequest request) {
        boolean b = true;
        try{
        	if(carInfo.getTotal() < 0){//临时停车、福地入库卸货存在不收费的情况
        		return renderError("账单总金额有误，请确认！");
    		}
        	//所属区域为空时，以计费类型所属区域为准
        	if(null == carInfo.getLocation() || "".equals(carInfo.getLocation())){
        		ChargeType chargeType = chargeTypeService.selectById(carInfo.getChargeType());
        		carInfo.setLocation(chargeType.getLocation());
        	}
        	String str_detail = StringEscapeUtils.unescapeHtml(carInfo.getPayDetail());
        	carInfo.setPaymentDetailList(JSON.parseArray(str_detail, PaymentDetail.class));
        	carInfo.setUpdateTime(DateUtil.getNowDateTimeString());
            carInfo.setUpdateUser(ShiroUtils.getLoginName());
            if("carOut".equals(type)){//车辆出库
            	carInfo.setOutUser(ShiroUtils.getLoginName());
            	carInfo.setCarStatus("1");//已出库
            }else{// 运抵/停车收费时，出库时间不更新
            	carInfo.setOutTime(null);
            	carInfo.setChargeType("1".equals(carInfo.getCarStatus()) ? null : carInfo.getChargeType());//已出库状态，不改变收费项目
            }
        	carInfoService.dealPayment(carInfo);
        }catch(Exception e){
        	b = false;
        	return renderError(e.getMessage());
        }
        
        if (b) {
            return renderSuccess("处理成功！");
        } else {
            return renderError("处理失败！");
        }
    }
    
    /**
     * 磅房录入货物净重列表
     * @param model
     * @return
     */
    @RequestMapping("/manualNetListPage")
    public String selectManualNetListPage(Model model) {
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
        return "bi/carInfo/manualNetList";
    }
    
    /**
     * 磅单录入货物净重页面
     * @param model
     * @param id
     * @return
     */
    @RequestMapping("/manualNetEditPage")
    public String manualNetEditPage(Model model, Long id) {
    	CarInfo carInfo = carInfoService.selectById(id);
        model.addAttribute("carInfo", carInfo);
        return "bi/carInfo/manualNetEdit";
    }
    
    /**
     * 货物净重录入
     * @param 
     * @return
     */
    @RequestMapping("/manualNetEdit")
    @ResponseBody
    public Object manualNetEdit(@Valid CarInfo carInfo) {
    	try{
    		carInfoService.updateById(carInfo);
    		ManualNetHistory historyQuery = new ManualNetHistory();
    		historyQuery.setCarId(carInfo.getId());
    		EntityWrapper<ManualNetHistory> ew = new EntityWrapper<ManualNetHistory>(historyQuery);
    		ManualNetHistory history = manualNetHistoryService.selectOne(ew);
    		if(null != history && history.getId() > 0){
    			history.setNetWeight(carInfo.getManualNetweight());
    			history.setUpdateUser(ShiroUtils.getShiroUser().getLoginName());
    			history.setUpdateTime(DateUtil.getNowDateTimeString());
    			manualNetHistoryService.updateById(history);
    		}else{
    			history = new ManualNetHistory();
    			history.setCarId(carInfo.getId());
        		history.setLocation(carInfo.getLocation());
        		history.setNetWeight(carInfo.getManualNetweight());
        		history.setCreateUser(ShiroUtils.getShiroUser().getLoginName());
        		history.setUpdateUser(ShiroUtils.getShiroUser().getLoginName());
        		history.setCreateTime(DateUtil.getNowDateTimeString());
        		history.setUpdateTime(DateUtil.getNowDateTimeString());
        		manualNetHistoryService.insert(history);
    		}
    	}catch(Exception e){
    		return renderError("录入失败！");
    	}
    	return renderSuccess("录入成功！");
    }
    
    /**
     * 选择车辆信息，适用于弹出页面
     * @return
     */
    @GetMapping("/selectCarInfoPage")
    public String selectCarInfoPage() {
        return "bi/carInfo/selectCarInfo";
    }
    
    /**
     * 获取车辆列表，适用于出库收费选择关联入库车辆
     * @param carInfo
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @return
     */
    @PostMapping("/selectCarList4CarOut")
    @ResponseBody
    public PageInfo selectCarList4CarOut(CarInfo carInfo, Integer page, Integer rows, String sort,String order) {
    	PageInfo pageInfo = new PageInfo(page, rows, sort, order);
    	Page<CarInfo> pages = getPage(page, rows, sort, order);
    	carInfo.setLocation(ShiroUtils.getShiroUser().getLocation());
    	pages.setRecords(carInfoService.selectCarList4CarOut(pages, carInfo));
    	pageInfo.setRows(pages.getRecords());
    	pageInfo.setTotal(pages.getTotal());
    	return pageInfo;
    }
}
