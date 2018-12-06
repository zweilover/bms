package com.zw.bms.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.enums.IdType;
import com.baomidou.mybatisplus.activerecord.Model;
import com.baomidou.mybatisplus.annotations.TableName;
import java.io.Serializable;

/**
 * <p>
 * 库房仓储表
 * </p>
 *
 * @author zhaiwei
 * @since 2018-08-31
 */
@TableName("bi_store_statement")
public class StoreStatement extends Model<StoreStatement> {

    private static final long serialVersionUID = 1L;

    /**
     * id主键
     */
	@TableId(value="id", type= IdType.AUTO)
	private Long id;
    /**
     * 车辆ID
     */
	@TableField("car_id")
	private Long carId;
    /**
     * 车牌号
     */
	@TableField("car_no")
	private String carNo;
    /**
     * 运通卡号
     */
	@TableField("card_no")
	private String cardNo;
    /**
     * 所属区域，字典code
     */
	private String location;
    /**
     * 客户ID
     */
	@TableField("customer_id")
	private Long customerId;
	/**
	 * 业务日期
	 */
	@TableField("busi_date")
	private String busiDate;
	/**
	 * 出车单号
	 */
	@TableField("out_stock_no")
	private String outStockNo;
    /**
     * 1:出库 2:入库
     */
	private String type;
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

	public Long getCarId() {
		return carId;
	}

	public void setCarId(Long carId) {
		this.carId = carId;
	}

	public String getCarNo() {
		return carNo;
	}

	public void setCarNo(String carNo) {
		this.carNo = carNo;
	}

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public Long getCustomerId() {
		return customerId;
	}

	public void setCustomerId(Long customerId) {
		this.customerId = customerId;
	}
	
	public String getBusiDate() {
		return busiDate;
	}

	public void setBusiDate(String busiDate) {
		this.busiDate = busiDate;
	}

	public String getOutStockNo() {
		return outStockNo;
	}

	public void setOutStockNo(String outStockNo) {
		this.outStockNo = outStockNo;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
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
