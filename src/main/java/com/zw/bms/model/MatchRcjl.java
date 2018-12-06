package com.zw.bms.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.enums.IdType;
import com.baomidou.mybatisplus.activerecord.Model;
import com.baomidou.mybatisplus.annotations.TableName;
import java.io.Serializable;

/**
 * <p>
 * 入仓匹配表
 * </p>
 *
 * @author zhaiwei
 * @since 2018-06-28
 */
@TableName("bi_match_rcjl")
public class MatchRcjl extends Model<MatchRcjl> {

    private static final long serialVersionUID = 1L;

    /**
     * ID主键
     */
	@TableId(value="id", type= IdType.AUTO)
	private Long id;
	
    /**
     * 入仓ID
     */
	@TableField("rc_id")
	private Long rcId;
	
	 /**
     * 出仓车牌号码
     */
	@TableField("rc_no")
	private String rcNo;
    /**
     * 车辆ID
     */
	@TableField("car_id")
	private Long carId;
	
    /**
     * 车牌号码
     */
	@TableField("car_no")
	private String carNo;
	/**
	 * 所属区域
	 */
	private String location;
	/**
	 * 入仓时间
	 */
	private String rcsj;
	/**
	 * 匹配方式
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

	public Long getRcId() {
		return rcId;
	}

	public void setRcId(Long rcId) {
		this.rcId = rcId;
	}

	public String getRcNo() {
		return rcNo;
	}

	public void setRcNo(String rcNo) {
		this.rcNo = rcNo;
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

	public String getRcsj() {
		return rcsj;
	}

	public void setRcsj(String rcsj) {
		this.rcsj = rcsj;
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
