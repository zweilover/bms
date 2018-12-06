package com.zw.bms.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.enums.IdType;
import com.baomidou.mybatisplus.activerecord.Model;
import com.baomidou.mybatisplus.annotations.TableName;
import java.io.Serializable;

/**
 * <p>
 * 计费账单明细
 * </p>
 *
 * @author zhaiwei
 * @since 2017-12-21
 */
@TableName("bi_payment_detail")
public class PaymentDetail extends Model<PaymentDetail> {

    private static final long serialVersionUID = 1L;

    /**
     * ID
     */
	@TableId(value="id", type= IdType.AUTO)
	private Long id;
    /**
     * 账单表id
     */
	@TableField("pay_id")
	private Long payId;
	/**
	 * 账单表id
	 */
	@TableField("car_id")
	private Long carId;
	/**
	 * 计费子项id
	 */
	@TableField("item_id")
	private Long itemId;
	/**
	 * 价格
	 */
	private Double price;
	/**
	 * 数量
	 */
	private Double count;
	
	/**
	 * 付款类型
	 */
	@TableField("payment_mode")
	private String paymentMode;
	
	/**
	 * 额外费用
	 */
	@TableField("extra_Charges")
	private Double extraCharges;
	/**
	 * 总价
	 */
	private Double amount;
	/**
	 * 备注
	 */
	private String remark;
	/**
	 * 账单日期
	 */
	@TableField("bill_time")
	private String billTime;
	/**
	 * 结转日期
	 */
	@TableField("daily_date")
	private String dailyDate;
	/**
	 * 创建人
	 */
	@TableField("create_user")
	private String createUser;
	
	/*******  不在数据库中的字段    **********/
	/**
	 * 计费子项名称
	 */
	@TableField(exist = false)
	private String itemName;
	/**
	 * 创建人名称
	 */
	@TableField(exist = false)
	private String createUserName;
	/**
	 * 付款类型
	 */
	@TableField(exist = false)
	private String paymentModeName;
	/**
	 * 是否可编辑
	 */
	@TableField(exist = false)
	private Boolean isEditable = false;
	
	/*******  不在数据库中的字段    **********/
	
	
	@Override
	protected Serializable pkVal() {
		return this.id;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getPayId() {
		return payId;
	}

	public void setPayId(Long payId) {
		this.payId = payId;
	}

	public Long getCarId() {
		return carId;
	}

	public void setCarId(Long carId) {
		this.carId = carId;
	}

	public Long getItemId() {
		return itemId;
	}

	public void setItemId(Long itemId) {
		this.itemId = itemId;
	}

	public Double getPrice() {
		return price;
	}

	public void setPrice(Double price) {
		this.price = price;
	}

	public Double getCount() {
		return count;
	}

	public void setCount(Double count) {
		this.count = count;
	}

	public Double getExtraCharges() {
		return extraCharges;
	}

	public void setExtraCharges(Double extraCharges) {
		this.extraCharges = extraCharges;
	}

	public Double getAmount() {
		return amount;
	}

	public void setAmount(Double amount) {
		this.amount = amount;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getBillTime() {
		return billTime;
	}

	public void setBillTime(String billTime) {
		this.billTime = billTime;
	}

	public String getDailyDate() {
		return dailyDate;
	}

	public void setDailyDate(String dailyDate) {
		this.dailyDate = dailyDate;
	}

	public String getCreateUser() {
		return createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public Boolean getIsEditable() {
		return isEditable;
	}

	public void setIsEditable(Boolean isEditable) {
		this.isEditable = isEditable;
	}

	public String getPaymentMode() {
		return paymentMode;
	}

	public void setPaymentMode(String paymentMode) {
		this.paymentMode = paymentMode;
	}

	public String getCreateUserName() {
		return createUserName;
	}

	public void setCreateUserName(String createUserName) {
		this.createUserName = createUserName;
	}

	public String getPaymentModeName() {
		return paymentModeName;
	}

	public void setPaymentModeName(String paymentModeName) {
		this.paymentModeName = paymentModeName;
	}
	
}
