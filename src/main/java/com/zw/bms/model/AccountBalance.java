package com.zw.bms.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.enums.IdType;
import com.baomidou.mybatisplus.activerecord.Model;
import com.baomidou.mybatisplus.annotations.TableName;
import java.io.Serializable;

/**
 * <p>
 * 
 * </p>
 *
 * @author zhaiwei
 * @since 2018-01-09
 */
@TableName("bi_account_balance")
public class AccountBalance extends Model<AccountBalance> {

    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
	@TableId(value="id", type= IdType.AUTO)
	private Long id;
    /**
     * 客户id
     */
	@TableField("customer_id")
	private Long customerId;
    /**
     * 年份
     */
	private String year;
    /**
     * 月份
     */
	private String month;
    /**
     * 当月支付金额
     */
	@TableField("payment_amount")
	private Double paymentAmount;
    /**
     * 当月欠款总额
     */
	@TableField("credit_amount")
	private Double creditAmount;
    /**
     * 上期结转数
     */
	@TableField("last_balance")
	private Double lastBalance;
    /**
     * 当期结转数
     */
	@TableField("current_balance")
	private Double currentBalance;
    /**
     * 备注
     */
	private String remark;
    /**
     * 创建人
     */
	@TableField("create_user")
	private String createUser;
    /**
     * 创建日期
     */
	@TableField("create_time")
	private String createTime;
    /**
     * 最后更新人
     */
	@TableField("update_user")
	private String updateUser;
    /**
     * 最后更新日期
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

	public String getYear() {
		return year;
	}

	public void setYear(String year) {
		this.year = year;
	}

	public String getMonth() {
		return month;
	}

	public void setMonth(String month) {
		this.month = month;
	}

	public Double getPaymentAmount() {
		return paymentAmount;
	}

	public void setPaymentAmount(Double paymentAmount) {
		this.paymentAmount = paymentAmount;
	}

	public Double getCreditAmount() {
		return creditAmount;
	}

	public void setCreditAmount(Double creditAmount) {
		this.creditAmount = creditAmount;
	}

	public Double getLastBalance() {
		return lastBalance;
	}

	public void setLastBalance(Double lastBalance) {
		this.lastBalance = lastBalance;
	}

	public Double getCurrentBalance() {
		return currentBalance;
	}

	public void setCurrentBalance(Double currentBalance) {
		this.currentBalance = currentBalance;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
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
