package com.zw.bms.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.enums.IdType;
import com.baomidou.mybatisplus.activerecord.Model;
import com.baomidou.mybatisplus.annotations.TableName;
import java.io.Serializable;

/**
 * <p>
 * 文件上传表
 * </p>
 *
 * @author zhaiwei
 * @since 2018-06-28
 */
@TableName("bi_upload_file")
public class UploadFile extends Model<UploadFile> {

    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
	@TableId(value="id", type= IdType.AUTO)
	private Long id;
    /**
     * 文件名称
     */
	@TableField("file_name")
	private String fileName;
    /**
     * 文件路径
     */
	@TableField("file_path")
	private String filePath;
    /**
     * 类型
     */
	private String type;
    /**
     * 状态，0：正常 3：删除
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


	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
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
