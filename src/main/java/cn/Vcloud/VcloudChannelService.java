package cn.Vcloud;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

import javax.websocket.server.ServerEndpoint;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.Setting.Setting;
import cn.Setting.Model.VcloudSetting;
import cn.Vcloud.VcloudHelper.ApiUrl;
import cn.util.DataConvert;
import cn.util.HttpUtils;
import cn.util.StringHelper;
import cn.util.Tools;

/**
 * 网易云直播/点播
 * @author xiaoxueling
 *
 */
@Service
public class VcloudChannelService {

	@Autowired
	Setting setting;
	
	/**
	 * 获取请求的head参数
	 * @return
	 */
	private Map<String, String>getHeadMap(){
		
		//return VcloudHelper.getHeadMap("b961747a509f934f3b71da19b491ec60", "842739d24a1d");
		
		VcloudSetting vcloudSetting=setting.getSetting(VcloudSetting.class);
		
		if(vcloudSetting!=null) {
			return VcloudHelper.getHeadMap(vcloudSetting.getAppKey(), vcloudSetting.getAppSecret());
		}
		return null;
	}
	
	/**
	 * 创建直播频道
	 * @param name 频道名称（最大长度64个字符，只支持中文、字母、数字和下划线）
	 * @return {"result":true/false,"msg":消息,data:需要保存的JSON数据}
	 */
	public Map<String, Object>creatChannel(String name){
		return  creatChannel(name,0);
	}
	
	/**
	 * 创建直播频道
	 * @param name 频道名称（最大长度64个字符，只支持中文、字母、数字和下划线）
	 * @param type 频道类型（0:rtmp）
	 * @return {"result":true/false,"msg":消息,data:需要保存的JSON数据}
	 */
	public Map<String, Object>creatChannel(String name,Integer type){
		Map<String, Object> resultMap=new HashMap<String,Object>();
		resultMap.put("result", false);
		resultMap.put("msg", "创建频道失败！");
		resultMap.put("data", "");
		try {
			
			if(StringHelper.IsNullOrEmpty(name)) {
				throw new Exception("频道名称不能为空！");
			}
			
			boolean flag=name.matches("^[a-zA-Z0-9_\u4e00-\u9fa5]+$");
			if(!flag) {
				throw new Exception("频道名称只支持中文、字母、数字和下划线！");
			}
			
			int byteLength=name.getBytes().length;
			if(byteLength>64) {
				throw new Exception("频道名称最大长度超过64个字符！");
			}
			if(type==null) {
				type=0;
			}
			Map<String,String>paramsMap=new HashMap<String,String>();
			paramsMap.put("name", name);
			paramsMap.put("type", type.toString());
			
			String url=ApiUrl.channel_create.getUrl();
			String responseStr=HttpUtils.httpPost(url, getHeadMap(), paramsMap);
			
			if(StringHelper.IsNullOrEmpty(responseStr)) {
				throw new Exception("没有返回值！");
			}
			
			Map responseMap=Tools.JsonToMap(responseStr);
			if(responseMap==null) {
				throw new Exception("解析返回JSON数据错误！");
			}
			
			flag=DataConvert.ToString(responseMap.get("code")).equals("200");
			if(!flag) {
				String errorMsg=DataConvert.ToString(responseMap.get("msg"));
				throw new Exception(errorMsg);
			}
			Map retMap=(Map)responseMap.get("ret");
			JSONObject jsonObject = new JSONObject(retMap);
			resultMap.put("result", true);
			resultMap.put("msg", "创建频道成功");
			resultMap.put("data",jsonObject.toString());
			
		} catch (Exception e) {
			resultMap.put("result", false);
			resultMap.put("msg",e.getMessage());
		}
		return resultMap;
	}
	
	/**
	 * 设置频道录制状态
	 * @param jsonStr 保存的json数据 
	 * @param needRecord 1-开启录制（默认）； 0-关闭录制
	 * @return {"result":true/false,"msg":消息}
	 */
	public Map<String,Object> channelSetAlwaysRecord(String jsonStr,Integer needRecord){
		return channelSetAlwaysRecord(jsonStr, needRecord,0, 45, null);
	}
	
	/**
	 * 设置频道录制状态
	 * @param jsonStr 保存的json数据 
	 * @param needRecord 1-开启录制（默认）； 0-关闭录制
	 * @param format 1-flv； 0-mp4 （默认）
	 * @param duration 录制切片时长(分钟)，5~120分钟 （默认 45）
	 * @param filename 录制后文件名（只支持中文、字母和数字），格式为filename_YYYYMMDD-HHmmssYYYYMMDD-HHmmss, 文件名录制起始时间（年月日时分秒) -录制结束时间（年月日时分秒)
	 * @return {"result":true/false,"msg":消息}
	 */
	public Map<String,Object> channelSetAlwaysRecord(String jsonStr,Integer needRecord,Integer format,Integer duration,String filename){
		
		Map<String, Object> resultMap=new HashMap<String,Object>();
		resultMap.put("result", false);
		resultMap.put("msg", "操作失败！");
		resultMap.put("data", "");
		try {
			
			if(StringHelper.IsNullOrEmpty(jsonStr)) {
				throw new Exception("jsonStr不能为空！");
			}
			//获取频道ID
			Map channelMap=Tools.JsonToMap(jsonStr);
			if(channelMap==null) {
				throw new Exception("获取频道ID失败！");
			}
			String cid=DataConvert.ToString(channelMap.get("cid"));
			
			if(StringHelper.IsNullOrEmpty(cid)) {
				throw new Exception("获取频道ID失败！");
			}
			if(needRecord==null) {
				needRecord=1;
			}
			if(format==null) {
				format=0;
			}
			if(duration==null) {
				duration=45;
			}			
			Map<String,String>paramsMap=new HashMap<String,String>();
			paramsMap.put("cid", cid);
			paramsMap.put("needRecord", needRecord.toString());
			paramsMap.put("format", format.toString());
			paramsMap.put("duration", duration.toString());
			if(!StringHelper.IsNullOrEmpty(filename)) {
				paramsMap.put("filename", filename);
			}
			String url=ApiUrl.channel_setAlwaysRecord.getUrl();
			String responseStr=HttpUtils.httpPost(url, getHeadMap(), paramsMap);
			
			if(StringHelper.IsNullOrEmpty(responseStr)) {
				throw new Exception("没有返回值！");
			}
			
			Map responseMap=Tools.JsonToMap(responseStr);
			if(responseMap==null) {
				throw new Exception("解析返回JSON数据错误！");
			}
			
			boolean flag=DataConvert.ToString(responseMap.get("code")).equals("200");
			if(!flag) {
				String errorMsg=DataConvert.ToString(responseMap.get("msg"));
				throw new Exception(errorMsg);
			}
			resultMap.put("result", true);
			resultMap.put("msg", "操作成功");
			
		} catch (Exception e) {
			resultMap.put("result", false);
			resultMap.put("msg",e.getMessage());
		}
		return resultMap;
	}
}
