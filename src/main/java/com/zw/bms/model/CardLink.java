package com.zw.bms.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.enums.IdType;
import com.baomidou.mybatisplus.activerecord.Model;
import com.baomidou.mybatisplus.annotations.TableName;
import java.io.Serializable;

/**
 * <p>
 * 运通卡关联表
 * </p>
 *
 * @author zhaiwei
 * @since 2018-08-01
 */
@TableName("bi_card_link")
public class CardLink extends Model<CardLink> {

    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
	@TableId(value="id", type= IdType.AUTO)
	private Long id;
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
     * 所属区域
     */
	private String location;
	/**
	 * 状态
	 */
	private String status;
	/**
	 * 备注
	 */
	private String remark;
    /**
     * 创建日期
     */
	@TableField("create_time")
	private String createTime;
    /**
     * 创建日期
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


	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
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

	public String getStatus() {
		return status;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
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

	@Override
	protected Serializable pkVal() {
		return this.id;
	}

}
