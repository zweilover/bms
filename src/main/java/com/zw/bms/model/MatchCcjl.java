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
 * @since 2018-06-28
 */
@TableName("bi_match_ccjl")
public class MatchCcjl extends Model<MatchCcjl> {

    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
	@TableId(value="id", type= IdType.AUTO)
	private Long id;
    /**
     * 出仓ID
     */
	@TableField("cc_id")
	private Long ccId;
    /**
     * 出仓车牌号码
     */
	@TableField("cc_no")
	private String ccNo;
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
	 * 出仓时间
	 */
	private String ccsj;
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

	public Long getCcId() {
		return ccId;
	}

	public void setCcId(Long ccId) {
		this.ccId = ccId;
	}

	public String getCcNo() {
		return ccNo;
	}

	public void setCcNo(String ccNo) {
		this.ccNo = ccNo;
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

	public String getType() {
		return type;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getCcsj() {
		return ccsj;
	}

	public void setCcsj(String ccsj) {
		this.ccsj = ccsj;
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
