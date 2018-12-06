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
 * @since 2017-11-30
 */
@TableName("bi_big_customer")
public class BigCustomer extends Model<BigCustomer> {

    private static final long serialVersionUID = 1L;

    /**
     * 客户ID,主键
     */
	@TableId(value="id", type= IdType.AUTO)
	private Long id;
    /**
     * 客户名称
     */
	private String name;
	/**
     * 排序
     */
	private Integer seq;
    /**
     * 联系电话
     */
	private String telephone;
	/**
	 * 联系地址
	 */
	private String address;
    /**
     * 是否允许月结，0:是，1:否
     */
	@TableField("is_credit")
	private String isCredit;
	/**
	 * 状态,0:正常 1:停用 2:删除
	 */
	private String status;
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
	 * 最后更新人
	 */
	@TableField("update_user")
	private String updateUser;
    /**
     * 创建时间
     */
	@TableField("create_time")
	private String createTime;
    /**
     * 最后更新日期
     */
	@TableField("update_time")
	private String updateTime;
	
	
	/*******  不在数据库中的字段    **********/
	/**
	 * 计费子项ID
	 */
	@TableField(exist = false)
	private String itemId;
	/**
	 * 计费子项名称
	 */
	@TableField(exist = false)
	private String itemName;
	/**
	 * 计费子项优惠价格
	 */
	@TableField(exist = false)
	private Double itemPrice;
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


	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}


	public Integer getSeq() {
		return seq;
	}


	public void setSeq(Integer seq) {
		this.seq = seq;
	}


	public String getTelephone() {
		return telephone;
	}


	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}


	public String getAddress() {
		return address;
	}


	public void setAddress(String address) {
		this.address = address;
	}


	public String getIsCredit() {
		return isCredit;
	}


	public void setIsCredit(String isCredit) {
		this.isCredit = isCredit;
	}


	public String getStatus() {
		return status;
	}


	public void setStatus(String status) {
		this.status = status;
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


	public String getUpdateUser() {
		return updateUser;
	}


	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
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


	public String getItemName() {
		return itemName;
	}


	public void setItemName(String itemName) {
		this.itemName = itemName;
	}


	public Double getItemPrice() {
		return itemPrice;
	}


	public void setItemPrice(Double itemPrice) {
		this.itemPrice = itemPrice;
	}


	public String getItemId() {
		return itemId;
	}


	public void setItemId(String itemId) {
		this.itemId = itemId;
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

}
