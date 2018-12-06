package com.zw.bms.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.enums.IdType;
import com.baomidou.mybatisplus.activerecord.Model;
import com.baomidou.mybatisplus.annotations.TableName;
import java.io.Serializable;

/**
 * <p>
 * 客户计费子项关联表
 * </p>
 *
 * @author zhaiwei
 * @since 2017-12-29
 */
@TableName("bi_customer_item")
public class CustomerItem extends Model<CustomerItem> {

    private static final long serialVersionUID = 1L;

    /**
     * id，主键
     */
	@TableId(value="id", type= IdType.AUTO)
	private Long id;
    /**
     * 客户id
     */
	@TableField("customer_id")
	private Long customerId;
    /**
     * 计费子项id
     */
	@TableField("item_id")
	private Long itemId;
    /**
     * 优惠价格
     */
	private Double price;
    /**
     * 备注
     */
	private String remark;
	/**
	 * 状态，0:生效，1:失效，2:删除
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
	private String itemName;
	
	@TableField(exist = false)
	private String customerName;

	/*******  不在数据库中的字段    **********/

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

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	@Override
	protected Serializable pkVal() {
		return this.id;
	}

}
