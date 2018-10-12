package cn.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import javax.servlet.http.HttpServletResponse;

public class ExcelUntil {

	/**
	 * 读取excel 公共方法
	 * @param is 文件流
	 * @param fileType 文件后缀
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("resource")
	public static List<Map<String, Object>> readExcel(InputStream is,String fileType){
		Workbook wb=null;
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		try{
			if(fileType.equals("xls")){
				wb=new HSSFWorkbook(is);
			}else if (fileType.equals("xlsx")) {
				wb = new XSSFWorkbook(is);
			} else {
				return null;
			}
			//循环每一页 并处理当前循环页
			for(int numSheet=0;numSheet<wb.getNumberOfSheets();numSheet++){
				Sheet sheet=wb.getSheetAt(numSheet);//这里表示当前页的数据
				if(sheet==null)
					continue; //如果当前页面没有数据则跳出循环 继续下一页
				//获取当前页的行数
				int rows=sheet.getLastRowNum();
				for(int rowNum=0;rowNum<=rows;rowNum++){
					Row row=sheet.getRow(rowNum); //取到当前行
					if(row!=null){
						int cellNum= row.getPhysicalNumberOfCells();
						Map<String, Object> map = new HashMap<String, Object>();
						for(int j=0;j<cellNum;j++){
							map.put(j+"", getValue(row.getCell(j)));
							String cellVa=getValue(row.getCell(j));
						}
						resultList.add(map);
					}
				}
			}
		}catch(Exception ex){

		}
		return resultList;
	}

	/**
	 * 获取值
	 * @param hssfRow
	 * @return
	 */
	public static String getValue(Cell hssfRow) {
		if (hssfRow.getCellType() == hssfRow.CELL_TYPE_BOOLEAN) {
			String boo=String.valueOf(hssfRow.getBooleanCellValue());
			if(StringUtils.isEmpty(boo))
				return null ;
			else
				return boo;
		} else if (hssfRow.getCellType() == hssfRow.CELL_TYPE_NUMERIC) {
			String num=String.valueOf((int)hssfRow.getNumericCellValue());
			if(StringUtils.isEmpty(num))
				return null;
			else  return num;
		} else{
			String str=hssfRow.getStringCellValue();
			if(StringUtils.isEmpty(str))
				return "";
			else return str;
		}
	}




	public HSSFWorkbook exprot(List list,String[] excelHeader,String[] mapKey){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		//创建工作簿
		HSSFWorkbook wb=new HSSFWorkbook();
		//创建工作表格
		HSSFFont fontStyle = wb.createFont();
		fontStyle.setFontName("微软雅黑");
		HSSFSheet sheet=wb.createSheet("sheet");
		//创建行
		HSSFRow row=sheet.createRow(0);
		//创建单元格 并将表头设置为居中
		HSSFCellStyle style=wb.createCellStyle();
		style.setBorderLeft(BorderStyle.THIN);
		style.setBorderRight(BorderStyle.THIN);
		style.setBorderTop(BorderStyle.THIN);
		HSSFFont font = wb.createFont();
		font.setFontName("仿宋_GB2312");
		font.setFontHeightInPoints((short) 12);
		font.setColor(HSSFFont.COLOR_RED);
		style.setAlignment(HSSFCellStyle.ALIGN_CENTER);//表格居中
		style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);//垂直
		style.setFont(font);
		//创建单元格 并将表头设置为居中
		HSSFCellStyle style2=wb.createCellStyle();
		style2.setBorderBottom(BorderStyle.THIN);
		style2.setBorderLeft(BorderStyle.THIN);
		style2.setBorderRight(BorderStyle.THIN);
		style2.setBorderTop(BorderStyle.THIN);
		style2.setBottomBorderColor(HSSFColor.BLACK.index);
		HSSFFont font2 = wb.createFont();
		font2.setFontName("仿宋_GB2312");
		style2.setAlignment(HSSFCellStyle.ALIGN_CENTER);//表格居中
		style2.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);//垂直
		//创建标题
		for(int i=0;i<excelHeader.length;i++){
			//标题的列
			HSSFCell cell=row.createCell(i);
			//标题列的写入
			cell.setCellValue(excelHeader[i]);
			//样式
			cell.setCellStyle(style);
			//每列长度自适应
			sheet.autoSizeColumn(i);
		}
		//创建内容 先判断有多少行 然后每一行添加每一列的数据
		int listLeg=list.size();
		int kegLeg=mapKey.length;
		for(int i=0;i<listLeg;i++){
			row=sheet.createRow(i+1);
			Map map=(Map)list.get(i);
			for(int j=0;j<kegLeg;j++){
				//每列长度自适应
				sheet.autoSizeColumn(j);
				//写入样式
				HSSFCell cell=row.createCell(j);
				cell.setCellStyle(style2);
				String key=mapKey[j];
				if(key.equals("isusing")){
					switch(map.get(key)+""){
						case "0":
							cell.setCellValue("禁用");
							break;
						case "1":
							cell.setCellValue("启用");
					}
				}else{
					if(StringUtils.isEmpty(map.get(key))){
						cell.setCellValue("");
					}else{
						cell.setCellValue(map.get(key)+"");
					}
				}
			}
		}
		return wb;
	}


	/**
	 * @param resultList 结果列表
	 * @param excelHeader 表格头部
	 * @param mapKey 列表key
	 * @param response
	 * @param titleName 表格文件名称
	 * @throws UnsupportedEncodingException
	 */
	public static void excelToFile(List<Map> resultList, String []excelHeader, String[] mapKey, HttpServletResponse response,String titleName) throws UnsupportedEncodingException {
		ExcelUntil ex = new ExcelUntil();
		HSSFWorkbook wb=ex.exprot(resultList,excelHeader,mapKey);
		SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMddHHmmss");
		String fileName = sdf.format(new Date()) + titleName;
		response.setContentType("application/vnd.ms-excel");
		response.setHeader( "Content-Disposition", "attachment;filename=" + new String( fileName.getBytes("gb2312"), "ISO8859-1" )+".xls" );
		OutputStream outputStream = null;
		try {
			outputStream = response.getOutputStream();
			wb.write(outputStream);
		} catch (IOException e) {
			e.printStackTrace();
		}finally{
			try {
				outputStream.flush();
				outputStream.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	
	
}
