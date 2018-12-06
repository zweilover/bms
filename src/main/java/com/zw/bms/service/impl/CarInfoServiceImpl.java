package com.zw.bms.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;
import org.apache.commons.lang.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.zw.bms.commons.constants.ConstantsUtil;
import com.zw.bms.commons.exception.CommonException;
import com.zw.bms.commons.utils.BeanUtils;
import com.zw.bms.commons.utils.DateUtil;
import com.zw.bms.commons.utils.MathUtils;
import com.zw.bms.commons.utils.ShiroUtils;
import com.zw.bms.commons.utils.StringUtils;
import com.zw.bms.mapper.AccountDetailMapper;
import com.zw.bms.mapper.BigCustomerMapper;
import com.zw.bms.mapper.CarInfoMapper;
import com.zw.bms.mapper.ChargeItemMapper;
import com.zw.bms.mapper.PaymentDetailMapper;
import com.zw.bms.mapper.PaymentMapper;
import com.zw.bms.model.AccountDetail;
import com.zw.bms.model.BigCustomer;
import com.zw.bms.model.CarInfo;
import com.zw.bms.model.ChargeItem;
import com.zw.bms.model.Payment;
import com.zw.bms.model.PaymentDetail;
import com.zw.bms.service.ICarInfoService;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-28
 */
@Service
public class CarInfoServiceImpl extends ServiceImpl<CarInfoMapper, CarInfo> implements ICarInfoService {

	@Autowired
	private CarInfoMapper carInfoMapper;
	
	@Autowired
	private ChargeItemMapper chargeItemMapper;
	
	@Autowired
	private BigCustomerMapper bigCustomerMapper;
	
	@Autowired
	private PaymentMapper paymentMapper;
	
	@Autowired
	private PaymentDetailMapper paymentDetailMapper;
	
	@Autowired
	private AccountDetailMapper accountDetailMapper;
	
	/**
	 * 洗净毛货位仓储费
	 */
	private static double BASEAMOUNT_XIJINGMAO = 1500d;
	/**
	 * 蓝湿皮货位仓储费
	 */
	private static double BASEAMOUNT_LANSHIPI = 1000d;
	/**
	 * 马皮驴皮货位仓储费
	 */
	private static double BASEAMOUNT_MAPI = 5000d;
	/**
	 * 羊皮货位仓储费
	 */
	private static double BASEAMOUNT_YANGPI = 6000d;
	/**
	 * 麝鼠皮货位仓储费
	 */
	private static double BASEAMOUNT_SHESHUPI = 4000d;
	
	@Override
	public List<CarInfo> selectCarInfoList(Page<CarInfo> page, CarInfo carInfo) {
		return carInfoMapper.selectCarInfoList(page, carInfo);
	}
	
	@Override
	public List<CarInfo> selectCarList4CarOut(Page<CarInfo> page,CarInfo carInfo){
		return carInfoMapper.selectCarList4CarOut(page, carInfo);
	}
	
	@Override
	public CarInfo getCarInfoDetail(Long id) {
		return carInfoMapper.getCarInfoDetail(id);
	}
	
	@Override
	public List<PaymentDetail> getPaymentDetailByCarId(Long id){
		return paymentDetailMapper.getPaymentDetailByCarId(id);
	}

	@Override
	public void checkUnique4CardInfo(CarInfo carInfo) {
		Integer i = 0;
		if(StringUtils.isNotBlank(carInfo.getCarNo())){
			EntityWrapper<CarInfo> ew = new EntityWrapper<CarInfo>();
			ew.and("car_status = {0} and car_no = {1}","0",carInfo.getCarNo().toUpperCase());
			if(null != carInfo.getId() && carInfo.getId() != 0){
				ew.and("id != {0}",carInfo.getId());
			}
			i = carInfoMapper.selectCount(ew);
			if(i > 0){
				throw new CommonException("该车牌号车辆已登记入库，请核实！");
			}
		}
		if(StringUtils.isNotBlank(carInfo.getCardNo())){
			EntityWrapper<CarInfo> ew = new EntityWrapper<CarInfo>();
			ew.and("car_status = {0} and card_no = {1}","0",carInfo.getCardNo());
			if(null != carInfo.getId() && carInfo.getId() != 0){
				ew.and("id != {0}",carInfo.getId());
			}
			i = carInfoMapper.selectCount(ew);
			if(i > 0){
				throw new CommonException("该运通卡号已登记入库，请核实！");
			}
		}
	}
	
	/**
	 * 生成计费明细
	 * @param carInfo 车辆信息
	 * @return 计费明细
	 */
	@Override
	public List<PaymentDetail> genPaymentDetail(CarInfo carInfo){
		List<PaymentDetail> lst_detail = new ArrayList<PaymentDetail>();
		List<ChargeItem> lst_items = chargeItemMapper.selectItemsByChargeType(carInfo.getChargeType());
		genPaymentDetailByItem(lst_items,lst_detail,carInfo);//根据计费子项生成计费明细
		doDetailAmountRound4FD(carInfo,lst_detail);//处理明细四舍五入
		genBigCustomerPaymentDetail(lst_items,lst_detail,carInfo);//生成大客户优惠明细
		genOthersPaymentDetail(lst_detail);//在最后一行添加其他计费项目
		return lst_detail;
	}
	
	/**
	 * 处理付款
	 */
	@Override
	@Transactional
	public void dealPayment(CarInfo carInfo){
		Long lon_charType = carInfo.getChargeType();//计费项目
		//1、保存车辆信息
		carInfoMapper.updateById(carInfo);
		
		//对于金额小于等于0,并且支付明细小于等于1条（默认会增加一条其他费用）的不生成付款单,
		if(null != carInfo.getTotal() && carInfo.getTotal() <= 0 && 
				null != carInfo.getPaymentDetailList() && carInfo.getPaymentDetailList().size() <= 1){
			return;
		}
		
		//2、保存付款单,针对同一车辆多次收费，需要特殊处理账单表
		EntityWrapper<Payment> ew = new EntityWrapper<Payment>();
		ew.and("car_id = {0}",carInfo.getId());
		List<Payment> payList = paymentMapper.selectList(ew);
		Payment payment = null;
		if(null != payList && payList.size() > 0){
			payment = payList.get(0);
			payment.setAmount(carInfo.getTotal() + payment.getAmount());
			payment.setPayedAmount(!"2".equals(carInfo.getPaymentMode()) ? carInfo.getTotal() + payment.getPayedAmount():payment.getPayedAmount());
		}else{
			payment = new Payment();
			payment.setCreateUser(ShiroUtils.getLoginName());
			payment.setCreateTime(DateUtil.getNowDateTimeString());
			payment.setPayTime(DateUtil.getNowDateTimeString());
			payment.setAmount(carInfo.getTotal());
			payment.setPayedAmount(!"2".equals(carInfo.getPaymentMode()) ? carInfo.getTotal():0);
		}
		payment.setCarId(carInfo.getId());
		payment.setCustomerId(carInfo.getCustomerId());
		payment.setChargeTypeId(lon_charType);
		payment.setBillTime(DateUtil.getNowDateTimeString());
		payment.setPaymentMode(carInfo.getPaymentMode());
		payment.setUpdateUser(ShiroUtils.getLoginName());
		payment.setUpdateTime(DateUtil.getNowDateTimeString());
		if(null != payment.getId()){
			paymentMapper.updateById(payment);
		}else{
			paymentMapper.insert(payment);
		}
		
		//3、保存付款明细
		for(PaymentDetail mx : carInfo.getPaymentDetailList()){
			if(null != mx.getAmount() && mx.getAmount() != 0){
				PaymentDetail detail = new PaymentDetail();
				BeanUtils.copyProperties(mx, detail);
				detail.setPayId(payment.getId());
				detail.setCarId(carInfo.getId());
				detail.setPaymentMode(carInfo.getPaymentMode());
				detail.setCreateUser(ShiroUtils.getLoginName());
				detail.setBillTime(DateUtil.getNowDateTimeString());
				paymentDetailMapper.insert(detail);
			}
		}
		
		//4、保存账户明细
		AccountDetail accountDetail = new AccountDetail();
		accountDetail.setCarId(carInfo.getId());
		accountDetail.setPayId(payment.getId());
		accountDetail.setChargeType(carInfo.getChargeType());
		accountDetail.setCustomerId(carInfo.getCustomerId());
		accountDetail.setAmount("2".equals(carInfo.getPaymentMode()) ? -(carInfo.getTotal()) : carInfo.getTotal());//月结时为负
		accountDetail.setRecordTime(DateUtil.getNowDateString());
		accountDetail.setStatus(ConstantsUtil.STATUS_NORMAL);
		accountDetail.setPaymentMode(carInfo.getPaymentMode());
		accountDetail.setPaymentType("1");
		accountDetail.setCreateTime(DateUtil.getNowDateTimeString());
		accountDetail.setCreateUser(ShiroUtils.getLoginName());
		accountDetail.setUpdateTime(DateUtil.getNowDateTimeString());
		accountDetail.setUpdateUser(ShiroUtils.getLoginName());
//		accountDetail.setRemark(""); //备注
		accountDetailMapper.insert(accountDetail);
	}
	/**
	 * 通过计费子项生成计费明细
	 * @param chargeItem
	 * @param lst_detail
	 * @return
	 */
	public void genPaymentDetailByItem(List<ChargeItem> lst_items,List<PaymentDetail> lst_detail,CarInfo carInfo){
		for(ChargeItem chargeItem : lst_items){
			boolean isExecutable = true;//脚本验证是否通过
			if(StringUtils.isNotBlank(chargeItem.getScriptStr()) && StringUtils.isNotBlank(chargeItem.getScriptParamCode())){
				ScriptEngineManager manager = new ScriptEngineManager();
				ScriptEngine engine = manager.getEngineByName("javascript");
				engine.put("param", getScriptParamValue(chargeItem.getScriptParamCode(),carInfo));
				if(StringUtils.isNotBlank(chargeItem.getItemParamCode())){
					engine.put("itemParam", getScriptParamValue(chargeItem.getItemParamCode(),carInfo));
				}
				try {
//					engine.eval("var flag=true;if(param=='1'){flag=false;}");
					engine.eval(StringEscapeUtils.unescapeHtml(chargeItem.getScriptStr()));
					isExecutable = (Boolean)engine.get("flag");
				} catch (ScriptException e) {
					isExecutable = true;
				}
			}
			if(isExecutable){//脚本验证通过,执行计算
				// [(param - min) ? max] * price 
				double d_paramValue = getItemParamValue(chargeItem.getItemParamCode(),carInfo);//参数值
				double d_count = d_paramValue > chargeItem.getMinValue() ? d_paramValue - chargeItem.getMinValue() : 0;
				if(chargeItem.getMaxValue() > 0){
					d_count = d_count > chargeItem.getMaxValue() ? d_count : chargeItem.getMaxValue();
				}
				if(d_count > 0){
					if(chargeItem.getName().indexOf("FD") >= 0 && chargeItem.getName().indexOf("超期堆存费") >= 0){//福地超期堆存费
						genOverStockDetail4FD(chargeItem,lst_detail,carInfo,d_count);
					}else{
						PaymentDetail detail = new PaymentDetail();
						detail.setItemId(chargeItem.getId());
						detail.setItemName(chargeItem.getName());
						detail.setPrice(chargeItem.getCost());
						detail.setPaymentMode(carInfo.getPaymentMode());
						if(chargeItem.getName().indexOf("FD_原毛") >= 0){//原毛= 价格 * 堆存天数 * 吨数
							double d_netWeight = (null != carInfo.getNetWeight() && carInfo.getNetWeight() > 18) ? carInfo.getNetWeight() : 18;
							detail.setCount(MathUtils.round(d_count * d_netWeight, 2));//四舍五入保留两位小数
							detail.setAmount(chargeItem.getCost() * d_count * d_netWeight);
						}else if(chargeItem.getName().indexOf("SQ_") >= 0 && chargeItem.getName().indexOf("车辆出口停车费") >= 0){
							//森桥车辆出口停车费 = 单价 * 停车天数 * 车辆数量
							detail.setCount(d_count * carInfo.getGoodsQuantity());
							detail.setAmount(chargeItem.getCost() * d_count * carInfo.getGoodsQuantity());
						}else if(chargeItem.getName().indexOf("SQ_") >= 0 && chargeItem.getName().indexOf("过磅费") >= 0){
							//过磅费总是向上取整
							detail.setCount(MathUtils.round2(d_count, 0, BigDecimal.ROUND_UP));
							detail.setAmount(chargeItem.getCost() * MathUtils.round2(d_count, 0, BigDecimal.ROUND_UP));
						}else if(chargeItem.getName().indexOf("SQ_管理费(") >= 0){
							//森桥管理费按净重区间收取
							detail.setCount(Double.valueOf("1"));
							detail.setAmount(chargeItem.getCost());
						}else{
							detail.setCount(d_count);
							detail.setAmount(chargeItem.getCost() * d_count);
						}
						detail.setRemark(chargeItem.getRemark());
						detail.setIsEditable(false);//是否允许修改
						lst_detail.add(detail);
					}
				}
			}
		}
	}
	
	/**
	 * 生成福地超期堆存费
	 * @param chargeItem
	 * @param lst_detail
	 * @param carInfo
	 * @param baseAmount
	 */
	public void genOverStockDetail4FD(ChargeItem chargeItem,List<PaymentDetail> lst_detail,CarInfo carInfo,double paramCount){
		PaymentDetail detail = new PaymentDetail();
		detail.setPaymentMode(carInfo.getPaymentMode());
		detail.setItemId(chargeItem.getId());
		detail.setItemName(chargeItem.getName());
		detail.setRemark(chargeItem.getRemark());
		detail.setIsEditable(false);//是否允许修改
		if(paramCount <= 15){
			detail.setPrice(chargeItem.getCost());
			detail.setCount(paramCount);
			detail.setAmount(chargeItem.getCost() * paramCount);
			lst_detail.add(detail);
		}else if(paramCount > 15 && paramCount <= 30){
			double baseAmount = this.getChargeBaseAmount4FD(chargeItem);
			detail.setPrice(baseAmount);
			detail.setCount(1d);
			detail.setAmount(baseAmount * 1d);
			lst_detail.add(detail);
		}else if(paramCount > 30){
			double baseAmount = this.getChargeBaseAmount4FD(chargeItem);
			int count =  (int) (paramCount/30);
			detail.setPrice(baseAmount);
			int mod = (int) (paramCount % 30);
			if(mod > 0 && mod <= 15){
				detail.setCount(count + 0d);
				detail.setAmount(baseAmount * count);
				lst_detail.add(detail);
				genOverStockDetail4FD(chargeItem,lst_detail,carInfo,mod);//取余小于15，超期部分 = （基础货位费用 * 整数）  + （设置金额  * 超期天数）
			}
			if(mod > 0 && mod > 15){//取余大于15，则数量加1，超期部分 = 基础货位费用 * （整数+1）
				detail.setCount(count + 1d);
				detail.setAmount(baseAmount * (count + 1d));
				lst_detail.add(detail);
			}
			
		}
		
	}
	
	/**
	 * 获取福地仓储费的基础货位费用
	 * @param chargeItem
	 * @return
	 */
	public double getChargeBaseAmount4FD(ChargeItem chargeItem){
		if(chargeItem.getName().indexOf("FD") >= 0 && chargeItem.getName().indexOf("洗净毛超期堆存费") >= 0){
			return BASEAMOUNT_XIJINGMAO;
		}
		if(chargeItem.getName().indexOf("FD") >= 0 && chargeItem.getName().indexOf("蓝湿皮超期堆存费") >= 0){
			return BASEAMOUNT_LANSHIPI;
		}
		if(chargeItem.getName().indexOf("FD") >= 0 && chargeItem.getName().indexOf("马皮驴皮超期堆存费") >= 0){
			return BASEAMOUNT_MAPI;
		}
		if(chargeItem.getName().indexOf("FD") >= 0 && chargeItem.getName().indexOf("羊皮超期堆存费") >= 0){
			return BASEAMOUNT_YANGPI;
		}
		if(chargeItem.getName().indexOf("FD") >= 0 && chargeItem.getName().indexOf("麝鼠皮超期堆存费") >= 0){
			return BASEAMOUNT_SHESHUPI;
		}
		return 0d;
	}
	
	/**
	 * 生成其他计费项目
	 * @param lst_detail
	 */
	public void genOthersPaymentDetail(List<PaymentDetail> lst_detail){
//		if(null != lst_detail && lst_detail.size() > 0){//未生成计费项目不添加其他项目
			PaymentDetail detail = new PaymentDetail();
			detail.setItemId(Long.valueOf("1"));
			detail.setItemName("其他费用");
			detail.setIsEditable(true);//是否允许修改
			lst_detail.add(detail);
//		}
	}
	
	/**
	 * 生成大客户优惠
	 * @param lst_items
	 * @param lst_detail
	 * @param carInfo
	 */
	public void genBigCustomerPaymentDetail(List<ChargeItem> lst_items,List<PaymentDetail> lst_detail,CarInfo carInfo){
		if(null != lst_detail && lst_detail.size() > 0 &&
				null != lst_items && lst_items.size() > 0 && 
				null != carInfo.getCustomerId() && carInfo.getCustomerId() > 0){//客户ID
			List<BigCustomer> lst_customer = bigCustomerMapper.getBigCustomerByChargeItem(carInfo.getCustomerId(), lst_items);
			if(null != lst_customer && lst_customer.size() > 0){
				for(BigCustomer customer : lst_customer){
					PaymentDetail detail = new PaymentDetail();
					detail.setItemId(Long.valueOf("2"));
					detail.setItemName("客户优惠");
					detail.setPrice(-customer.getItemPrice()); //优惠金额为负数
					detail.setCount(Double.valueOf("1"));
					detail.setAmount(-customer.getItemPrice());//因数量为1，所以价格=总价
					detail.setRemark(customer.getItemName());
					detail.setIsEditable(false);//是否允许修改
					lst_detail.add(detail);
				}
			}
		}
	}
	
	/**
	 * 按整数位四舍五入
	 * @param carInfo
	 * @param lst_detail
	 */
	private void doDetailAmountRound4FD(CarInfo carInfo,List<PaymentDetail> lst_detail){
		if("FD".equals(carInfo.getLocation())){ //福地
			for(PaymentDetail detail : lst_detail){
				detail.setAmount(MathUtils.round(detail.getAmount(), 0));
			}
		}
	}
	
	/**
	 * 获取计费子项参数值
	 * @param itemCode
	 * @param carInfo
	 * @return
	 */
	public double getItemParamValue(String itemCode,CarInfo carInfo){
		double paramValue = 1d;
		if(StringUtils.isNotBlank(itemCode) && "HWJZ".equals(itemCode)){//货物净重
			paramValue = carInfo.getNetWeight();
		}
		if(StringUtils.isNotBlank(itemCode) && "TCTS".equals(itemCode)){//停车天数
			paramValue = carInfo.getParkDays();
		}
		if(StringUtils.isNotBlank(itemCode) && "DCTS".equals(itemCode)){//堆存天数
			paramValue = carInfo.getStockDays();
		}
		if(StringUtils.isNotBlank(itemCode) && "HWSL".equals(itemCode)){//货物数量
			paramValue = carInfo.getGoodsQuantity();
		}
		return paramValue;
	}
	
	/**
	 * 获取计费脚本参数值
	 * @param itemCode
	 * @param carInfo
	 * @return
	 */
	public String getScriptParamValue(String itemCode,CarInfo carInfo){
		String paramValue = "";
		if(StringUtils.isNotBlank(itemCode) && "SFNK".equals(itemCode)){//是否年卡
			paramValue = carInfo.getIsYearCard();
		}
		if(StringUtils.isNotBlank(itemCode) && "HWJZ".equals(itemCode)){//货物净重
			paramValue = String.valueOf(carInfo.getNetWeight());
		}
		if(StringUtils.isNotBlank(itemCode) && "DCTS".equals(itemCode)){//堆存天数
			paramValue = String.valueOf(carInfo.getStockDays());
		}
		if(StringUtils.isNotBlank(itemCode) && "TCTS".equals(itemCode)){//停车天数
			paramValue = String.valueOf(carInfo.getParkDays());
		}
		return paramValue;
	}

}
