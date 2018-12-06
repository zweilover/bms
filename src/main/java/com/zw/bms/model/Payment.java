package com.zw.bms.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.enums.IdType;
import com.baomidou.mybatisplus.activerecord.Model;
import com.baomidou.mybatisplus.annotations.TableName;
import java.io.Serializable;

/**
 * <p>
 * 计费账单表
 * </p>
 *
 * @author zhaiwei
 * @since 2018-01-04
 */
@TableName("bi_payment")
public class Payment extends Model<Payment> {

    private static final long serialVersionUID = 1L;

    /**
     * 主键id
     */
	@TableId(value="id", type= IdType.AUTO)
	private Long id;
    /**
     * 客户id
     */
	@TableField("customer_id")
	private Long customerId;
    /**
     * 关联的车辆信息id
     */
	@TableField("car_id")
	private Long carId;
    /**
     * 计费项目id
     */
	@TableField("charge_type_id")
	private Long chargeTypeId;
    /**
     * 账单总金额
     */
	private Double amount;
    /**
     * 已支付金额
     */
	@TableField("payed_amount")
	private Double payedAmount;
    /**
     *  状态 1:现金结算 2:月结待付
     */
	@TableField("payment_mode")
	private String paymentMode;
    /**
     * 账单日期
     */
	@TableField("bill_time")
	private String billTime;
    /**
     * 付款日期
     */
	@TableField("pay_time")
	private String payTime;
    /**
     * 创建人
     */
	@TableField("create_user")
	private String createUser;
    /**
     * 创建时间
     */
	@TableField("create_time")
	private String createTime;
    /**
     * 最后更新人
     */
	@TableField("update_user")
	private String updateUser;
    /**
     * 最后更新时间
     */
	@TableField("update_time")
	private String updateTime;


	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getCustomerId() {
		return customerId;
	}

	public void setCustomerId(Long customerId) {
		this.customerId = customerId;
	}

	public Long getCarId() {
		return carId;
	}

	public void setCarId(Long carId) {
		this.carId = carId;
	}

	public Long getChargeTypeId() {
		return chargeTypeId;
	}

	public void setChargeTypeId(Long chargeTypeId) {
		this.chargeTypeId = chargeTypeId;
	}

	public Double getAmount() {
		return amount;
	}

	public void setAmount(Double amount) {
		this.amount = amount;
	}

	public Double getPayedAmount() {
		return payedAmount;
	}

	public void setPayedAmount(Double payedAmount) {
		this.payedAmount = payedAmount;
	}

	public String getPaymentMode() {
		return paymentMode;
	}

	public void setPaymentMode(String paymentMode) {
		this.paymentMode = paymentMode;
	}

	public String getBillTime() {
		return billTime;
	}

	public void setBillTime(String billTime) {
		this.billTime = billTime;
	}

	public String getPayTime() {
		return payTime;
	}

	public void setPayTime(String payTime) {
		this.payTime = payTime;
	}

	public String getCreateUser() {
		return createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	public String getCreateTime() {
		return createTime;
	}

	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}

	public String getUpdateUser() {
		return updateUser;
	}

	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}

	public String getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}

	@Override
	protected Serializable pkVal() {
		return this.id;
	}

}
