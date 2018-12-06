package com.zw.bms.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.enums.IdType;
import com.baomidou.mybatisplus.activerecord.Model;
import com.baomidou.mybatisplus.annotations.TableName;
import java.io.Serializable;
import java.util.List;

/**
 * <p>
 * 
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-28
 */
@TableName("bi_car_info")
public class CarInfo extends Model<CarInfo> {

    private static final long serialVersionUID = 1L;

    /**
     * id,主键
     */
	@TableId(value="id", type= IdType.AUTO)
	private Long id;
    /**
     * 运通卡号
     */
	@TableField("card_no")
	private String cardNo;
    /**
     * 是否临时卡
     */
	@TableField("is_year_card")
	private String isYearCard;
    /**
     * 车牌号
     */
	@TableField("car_no")
	private String carNo;
	/**
	 * 所属区域
	 */
	private String location;
	/**
	 * 客户id
	 */
	@TableField("customer_id")
	private Long customerId;
	/**
	 * 计费项目
	 */
	@TableField("charge_type")
	private Long chargeType;
	/**
	 * 入库登记人
	 */
	@TableField("in_user")
	private String inUser;
    /**
     * 车辆入库时间
     */
	@TableField("in_time")
	private String inTime;
    /**
     * 车辆入库描述
     */
	@TableField("in_remark")
	private String inRemark;
	/**
	 * 出库登记人
	 */
	@TableField("out_user")
	private String outUser;
    /**
     * 车辆出库时间
     */
	@TableField("out_time")
	private String outTime;
	/**
	 * 车辆出库描述
	 */
	@TableField("out_remark")
	private String outRemark;
	/**
	 * 商品入库日期
	 */
	@TableField("goods_in_time")
	private String goodsInTime;
	/**
	 * 商品出库日期
	 */
	@TableField("goods_out_time")
	private String goodsOutTime;
	/**
	 * 货物名称
	 */
	@TableField("goods_name")
	private Long goodsName;
	/**
	 * 货物数量
	 */
	@TableField("goods_quantity")
	private Integer goodsQuantity;
	/**
	 * 货位号
	 */
	@TableField("goods_store_no")
	private String goodsStoreNo;
	/**
	 * 货物入库车辆
	 */
	@TableField("goods_in_car_id")
	private Long goodsInCarId;
	/**
	 * 出车单号
	 */
	@TableField("out_stock_no")
	private String outStockNo;
	/**
	 * 合同号
	 */
	@TableField("contract_no")
	private String contractNo;
	/**
	 * 运单号
	 */
	@TableField("waybill_no")
	private String waybillNo;
	/**
	 * 车辆停车天数
	 */
	@TableField("park_days")
	private Integer parkDays;
	/**
	 * 商品库存天数
	 */
	@TableField("stock_days")
	private Integer stockDays;
	/**
	 * 车辆净重
	 */
	@TableField("net_weight")
	private Double netWeight;
	
	/**
	 * 录入净重
	 */
	@TableField("manual_netweight")
	private Double manualNetweight;
	/**
	 * 车辆毛重
	 */
	@TableField("gross_weight")
	private Double grossWeight;
    /**
     * 车辆状态 0:已入库 1:已出库 2:已删除
     */
	@TableField("car_status")
	private String carStatus;
	/**
	 * 付款类型 1：现金结算 2：月结支付
	 */
	@TableField("payment_mode")
	private String paymentMode;
	/**
	 * 创建人
	 */
	@TableField("create_user")
	private String createUser;
	/**
	 * 最后更新人
	 */
	@TableField("update_user")
	private String updateUser;
    /**
     * 创建日期
     */
	@TableField("create_time")
	private String createTime;
    /**
     * 更新日期
     */
	@TableField("update_time")
	private String updateTime;
	
	
	/*******  不在数据库中的字段    **********/
	
	/**
	 * 费用总计
	 */
	@TableField(exist = false)
	private Double total;
	/**
	 * 付款明细
	 */
	@TableField(exist = false)
	private List<PaymentDetail> paymentDetailList;
	/**
	 * 付款明细
	 */
	@TableField(exist = false)
	private String payDetail;
	
	/**
	 * 客户名称
	 */
	@TableField(exist = false)
	private String customerName;
	
	/**
	 * 客户是否支持月结
	 */
	@TableField(exist = false)
	private String customerIsCredit;
	
	/**
	 * 所属区域名称
	 */
	@TableField(exist = false)
	private String locationName;
	
	/**
	 * 入库登记人名称
	 */
	@TableField(exist = false)
	private String inUserName;
	/**
	 * 出库登记人名称
	 */
	@TableField(exist = false)
	private String outUserName;
	/**
	 * 创建人名称
	 */
	@TableField(exist = false)
	private String createUserName;
	/**
	 * 最后更新人名称
	 */
	@TableField(exist = false)
	private String updateUserName;
	/**
	 * 货物入库车牌号
	 */
	@TableField(exist = false)
	private String goodsInCarNo;
	
	/**
	 * 计费项目名称
	 */
	@TableField(exist = false)
	private String chargeTypeName;
	
	/**
	 * 检查标识
	 */
	@TableField(exist = false)
	private String checkFlag;

	
	/*******  不在数据库中的字段    **********/

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public String getIsYearCard() {
		return isYearCard;
	}

	public void setIsYearCard(String isYearCard) {
		this.isYearCard = isYearCard;
	}

	public String getCarNo() {
		return carNo;
	}

	public void setCarNo(String carNo) {
		this.carNo = carNo;
	}
	
	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getInTime() {
		return inTime;
	}

	public void setInTime(String inTime) {
		this.inTime = inTime;
	}

	public String getInRemark() {
		return inRemark;
	}

	public void setInRemark(String inRemark) {
		this.inRemark = inRemark;
	}

	public String getOutTime() {
		return outTime;
	}

	public void setOutTime(String outTime) {
		this.outTime = outTime;
	}

	public String getCarStatus() {
		return carStatus;
	}

	public void setCarStatus(String carStatus) {
		this.carStatus = carStatus;
	}

	public String getCreateTime() {
		return createTime;
	}

	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}

	public String getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}
	
	public String getInUser() {
		return inUser;
	}

	public void setInUser(String inUser) {
		this.inUser = inUser;
	}

	public String getOutUser() {
		return outUser;
	}

	public void setOutUser(String outUser) {
		this.outUser = outUser;
	}

	public String getCreateUser() {
		return createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	public String getUpdateUser() {
		return updateUser;
	}

	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}
	
	public String getLocationName() {
		return locationName;
	}

	public void setLocationName(String locationName) {
		this.locationName = locationName;
	}

	public String getInUserName() {
		return inUserName;
	}

	public void setInUserName(String inUserName) {
		this.inUserName = inUserName;
	}

	public String getOutUserName() {
		return outUserName;
	}

	public void setOutUserName(String outUserName) {
		this.outUserName = outUserName;
	}

	public String getCreateUserName() {
		return createUserName;
	}

	public void setCreateUserName(String createUserName) {
		this.createUserName = createUserName;
	}

	public String getUpdateUserName() {
		return updateUserName;
	}

	public void setUpdateUserName(String updateUserName) {
		this.updateUserName = updateUserName;
	}

	public Long getCustomerId() {
		return customerId;
	}

	public void setCustomerId(Long customerId) {
		this.customerId = customerId;
	}

	public Long getChargeType() {
		return chargeType;
	}

	public void setChargeType(Long chargeType) {
		this.chargeType = chargeType;
	}

	public String getOutRemark() {
		return outRemark;
	}

	public void setOutRemark(String outRemark) {
		this.outRemark = outRemark;
	}

	public String getGoodsInTime() {
		return goodsInTime;
	}

	public void setGoodsInTime(String goodsInTime) {
		this.goodsInTime = goodsInTime;
	}

	public String getGoodsOutTime() {
		return goodsOutTime;
	}

	public void setGoodsOutTime(String goodsOutTime) {
		this.goodsOutTime = goodsOutTime;
	}

	public Long getGoodsName() {
		return goodsName;
	}

	public void setGoodsName(Long goodsName) {
		this.goodsName = goodsName;
	}

	public String getGoodsStoreNo() {
		return goodsStoreNo;
	}

	public void setGoodsStoreNo(String goodsStoreNo) {
		this.goodsStoreNo = goodsStoreNo;
	}

	public Long getGoodsInCarId() {
		return goodsInCarId;
	}

	public void setGoodsInCarId(Long goodsInCarId) {
		this.goodsInCarId = goodsInCarId;
	}

	public String getGoodsInCarNo() {
		return goodsInCarNo;
	}

	public void setGoodsInCarNo(String goodsInCarNo) {
		this.goodsInCarNo = goodsInCarNo;
	}

	public Integer getParkDays() {
		return parkDays;
	}

	public void setParkDays(Integer parkDays) {
		this.parkDays = parkDays;
	}

	public Integer getStockDays() {
		return stockDays;
	}

	public void setStockDays(Integer stockDays) {
		this.stockDays = stockDays;
	}

	public Double getNetWeight() {
		return netWeight;
	}

	public void setNetWeight(Double netWeight) {
		this.netWeight = netWeight;
	}

	public Double getManualNetweight() {
		return manualNetweight;
	}

	public void setManualNetweight(Double manualNetweight) {
		this.manualNetweight = manualNetweight;
	}

	public Double getGrossWeight() {
		return grossWeight;
	}

	public void setGrossWeight(Double grossWeight) {
		this.grossWeight = grossWeight;
	}

	public String getPaymentMode() {
		return paymentMode;
	}

	public void setPaymentMode(String paymentMode) {
		this.paymentMode = paymentMode;
	}

	public List<PaymentDetail> getPaymentDetailList() {
		return paymentDetailList;
	}

	public void setPaymentDetailList(List<PaymentDetail> paymentDetailList) {
		this.paymentDetailList = paymentDetailList;
	}

	public String getPayDetail() {
		return payDetail;
	}

	public void setPayDetail(String payDetail) {
		this.payDetail = payDetail;
	}

	public Double getTotal() {
		return total;
	}

	public void setTotal(Double total) {
		this.total = total;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getOutStockNo() {
		return outStockNo;
	}

	public void setOutStockNo(String outStockNo) {
		this.outStockNo = outStockNo;
	}

	public Integer getGoodsQuantity() {
		return goodsQuantity;
	}

	public void setGoodsQuantity(Integer goodsQuantity) {
		this.goodsQuantity = goodsQuantity;
	}

	public String getContractNo() {
		return contractNo;
	}

	public void setContractNo(String contractNo) {
		this.contractNo = contractNo;
	}

	public String getWaybillNo() {
		return waybillNo;
	}

	public void setWaybillNo(String waybillNo) {
		this.waybillNo = waybillNo;
	}

	public String getChargeTypeName() {
		return chargeTypeName;
	}

	public void setChargeTypeName(String chargeTypeName) {
		this.chargeTypeName = chargeTypeName;
	}

	public String getCheckFlag() {
		return checkFlag;
	}

	public void setCheckFlag(String checkFlag) {
		this.checkFlag = checkFlag;
	}

	public String getCustomerIsCredit() {
		return customerIsCredit;
	}

	public void setCustomerIsCredit(String customerIsCredit) {
		this.customerIsCredit = customerIsCredit;
	}

	@Override
	protected Serializable pkVal() {
		return this.id;
	}

}
