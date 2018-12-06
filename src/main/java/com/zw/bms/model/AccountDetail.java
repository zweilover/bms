package com.zw.bms.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.enums.IdType;
import com.baomidou.mybatisplus.activerecord.Model;
import com.baomidou.mybatisplus.annotations.TableName;
import java.io.Serializable;

/**
 * <p>
 * 客户账户明细
 * </p>
 *
 * @author zhaiwei
 * @since 2018-01-04
 */
@TableName("bi_account_detail")
public class AccountDetail extends Model<AccountDetail> {

    private static final long serialVersionUID = 1L;

    /**
     * ID，主键
     */
	@TableId(value="id", type= IdType.AUTO)
	private Long id;
    /**
     * 车辆id
     */
	@TableField("car_id")
	private Long carId;
    /**
     * 账单id
     */
	@TableField("pay_id")
	private Long payId;
    /**
     * 计费项目
     */
	@TableField("charge_type")
	private Long chargeType;
    /**
     * 客户id
     */
	@TableField("customer_id")
	private Long customerId;
    /**
     * 金额
     */
	private Double amount;
    /**
     * 记账日期
     */
	@TableField("record_time")
	private String recordTime;
	
	/**
	 * 回款月份
	 */
	@TableField("payment_month")
	private String paymentMonth;
    /**
     * 备注
     */
	private String remark;
    /**
     * 付款类型，1:现金  2:月结 3:刷卡 4:微信 5:支付宝 9:客户回款
     */
	@TableField("payment_mode")
	private String paymentMode;
	
	/**
	 * 付款来源,1:车辆出库 2:客户回款
	 */
	@TableField("payment_type")
	private String paymentType;
	
	/**
	 * 状态,0:正常 2:删除
	 */
	private String status;

	/**
     * 创建日期
     */
	@TableField("create_time")
	private String createTime;
    /**
     * 创建人
     */
	@TableField("create_user")
	private String createUser;
    /**
     * 最后更新日期
     */
	@TableField("update_time")
	private String updateTime;
    /**
     * 最后更新人
     */
	@TableField("update_user")
	private String updateUser;
	
	/*******  不在数据库中的字段    **********/
	
	@TableField(exist = false)
	private String chargeTypeName; 
	
	@TableField(exist = false)
	private String customerName; 
	
	@TableField(exist = false)
	private String createUserName; 
	
	@TableField(exist = false)
	private String updateUserName; 
	
	@TableField(exist = false)
	private String paymentModeName; 
	
	/*******  不在数据库中的字段    **********/


	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getCarId() {
		return carId;
	}

	public void setCarId(Long carId) {
		this.carId = carId;
	}

	public Long getPayId() {
		return payId;
	}

	public void setPayId(Long payId) {
		this.payId = payId;
	}

	public Long getChargeType() {
		return chargeType;
	}

	public void setChargeType(Long chargeType) {
		this.chargeType = chargeType;
	}

	public Long getCustomerId() {
		return customerId;
	}

	public void setCustomerId(Long customerId) {
		this.customerId = customerId;
	}

	public Double getAmount() {
		return amount;
	}

	public void setAmount(Double amount) {
		this.amount = amount;
	}

	public String getRecordTime() {
		return recordTime;
	}

	public void setRecordTime(String recordTime) {
		this.recordTime = recordTime;
	}

	public String getPaymentMonth() {
		return paymentMonth;
	}

	public void setPaymentMonth(String paymentMonth) {
		this.paymentMonth = paymentMonth;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getPaymentMode() {
		return paymentMode;
	}

	public void setPaymentMode(String paymentMode) {
		this.paymentMode = paymentMode;
	}

	public String getPaymentType() {
		return paymentType;
	}

	public void setPaymentType(String paymentType) {
		this.paymentType = paymentType;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getCreateTime() {
		return createTime;
	}

	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}

	public String getCreateUser() {
		return createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	public String getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}

	public String getUpdateUser() {
		return updateUser;
	}

	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}
	
	public String getChargeTypeName() {
		return chargeTypeName;
	}

	public void setChargeTypeName(String chargeTypeName) {
		this.chargeTypeName = chargeTypeName;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
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

	public String getPaymentModeName() {
		return paymentModeName;
	}

	public void setPaymentModeName(String paymentModeName) {
		this.paymentModeName = paymentModeName;
	}

	@Override
	protected Serializable pkVal() {
		return this.id;
	}

}
