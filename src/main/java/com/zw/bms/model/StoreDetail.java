package com.zw.bms.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.enums.IdType;
import com.baomidou.mybatisplus.activerecord.Model;
import com.baomidou.mybatisplus.annotations.TableName;
import java.io.Serializable;

/**
 * <p>
 * 库房仓储明细表
 * </p>
 *
 * @author zhaiwei
 * @since 2018-08-31
 */
@TableName("bi_store_detail")
public class StoreDetail extends Model<StoreDetail> {

    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
	@TableId(value="id", type= IdType.AUTO)
	private Long id;
    /**
     * 库房仓储表id
     */
	@TableField("statement_id")
	private Long statementId;
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
	 * 所属区域
	 */
	private String location;
    /**
     * 客户id
     */
	@TableField("customer_id")
	private Long customerId;
    
    /**
     * 库房ID
     */
	@TableField("store_id")
	private Long storeId;
    /**
     * 库房名称
     */
	@TableField("store_name")
	private String storeName;
	/**
	 * 货物ID
	 */
	@TableField("goods_id")
	private Long goodsId;
	/**
	 * 货物名称
	 */
	@TableField("goods_name")
	private String goodsName;
	
	/**
	 * 货物净重
	 */
	@TableField("net_weight")
	private Double netWeight;
	
	/**
	 * 数量
	 */
	private Double amount;
	
    /**
     * 备注
     */
	private String remark;
	
	/**
	 * 业务日期
	 */
	@TableField("busi_date")
	private String busiDate;
	
	/**
	 * 业务类型：'1:出库 2:入库'
	 */
	private String type;
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
     * 更新人
     */
	@TableField("update_user")
	private String updateUser;
    /**
     * 更新日期
     */
	@TableField("update_time")
	private String updateTime;


	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getStatementId() {
		return statementId;
	}

	public void setStatementId(Long statementId) {
		this.statementId = statementId;
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

	public Long getStoreId() {
		return storeId;
	}

	public void setStoreId(Long storeId) {
		this.storeId = storeId;
	}

	public String getStoreName() {
		return storeName;
	}

	public void setStoreName(String storeName) {
		this.storeName = storeName;
	}

	public Long getGoodsId() {
		return goodsId;
	}

	public void setGoodsId(Long goodsId) {
		this.goodsId = goodsId;
	}

	public String getGoodsName() {
		return goodsName;
	}

	public void setGoodsName(String goodsName) {
		this.goodsName = goodsName;
	}

	public Double getNetWeight() {
		return netWeight;
	}

	public void setNetWeight(Double netWeight) {
		this.netWeight = netWeight;
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
	
	public String getBusiDate() {
		return busiDate;
	}

	public void setBusiDate(String busiDate) {
		this.busiDate = busiDate;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
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
