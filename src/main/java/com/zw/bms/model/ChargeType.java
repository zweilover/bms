package com.zw.bms.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.enums.IdType;
import com.baomidou.mybatisplus.activerecord.Model;
import com.baomidou.mybatisplus.annotations.TableName;
import java.io.Serializable;

/**
 * <p>
 * 计费项目
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-18
 */
@TableName("bi_charge_type")
public class ChargeType extends Model<ChargeType> {

    private static final long serialVersionUID = 1L;

    /**
     * 主键id
     */
	@TableId(value="id", type= IdType.AUTO)
	private Long id;
	
    /**
     * 收费类型名称
     */
	private String name;
	
    /**
     * 费用所属区域,对应字典code
     */
	private String location;
	
    /**
     * 排序
     */
	private Integer seq;
	
    /**
     * 状态,0正常;1停用;
     */
	private String status;
	
    /**
     * 收费类型描述
     */
	private String description;
	
    /**
     * 创建时间
     */
	@TableField("create_time")
	private String createTime;
	
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
	 * 最后修改时间
	 */
	@TableField("update_time")
	private String updateTime;
	
	/*******  不在数据库中的字段    **********/
	
	/**
	 * 费用所属区域名称
	 */
	@TableField(exist = false)
	private String locationName;
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

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}
	
	public String getLocationName() {
		return locationName;
	}

	public void setLocationName(String locationName) {
		this.locationName = locationName;
	}

	public Integer getSeq() {
		return seq;
	}

	public void setSeq(Integer seq) {
		this.seq = seq;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
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

	@Override
	protected Serializable pkVal() {
		return this.id;
	}

}
