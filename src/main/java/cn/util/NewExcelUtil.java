package cn.util;

import java.io.InputStream;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.util.StringUtils;

public class NewExcelUtil {
	
	/*
	 * 	is excel流文件
	 * 	pre excel的后缀名
	 * 
	 * */
	
	//私有方法
		public static List<Map> isXlsOrXlsx(InputStream is,String pre,Map EngName){
			List<Map> resultList=new ArrayList<Map>();
			try {
				if(pre.equals("xlsx")){
					resultList=readXlsx(is,EngName);
				}else{
					resultList=readXls(is,EngName);
				}
				return resultList;
			} catch (Exception e) {
				e.printStackTrace();
				return null;
			}
		}
		
		/*
		 * 	readXlsx 读取xlsx格式
		 * */
		public static List<Map> readXlsx(InputStream is,Map EngName) throws Exception{
			List<Map> titleList = new ArrayList<Map>();//标题行的list
			List<Map> resultList = new ArrayList();//最终的list
			
			XSSFWorkbook wb=new XSSFWorkbook(is); //获取整个Excel文档
			for(int numSheet=0;numSheet<wb.getNumberOfSheets();numSheet++){//循环sheet
				XSSFSheet sheet=wb.getSheetAt(numSheet);//这里表示当前页的数据
				if(sheet==null)
					continue; //如果当前页面没有数据则跳出循环 继续下一页
				//获取当前页的行数
				int rows=sheet.getLastRowNum();
				//当前sheet的列数
				int coloumNum = 0;
				if(rows!=0){
					coloumNum=sheet.getRow(0).getPhysicalNumberOfCells();
				}
				if(rows==0 && coloumNum==0){
					continue;
				}
				XSSFRow rowFirst=sheet.getRow(0); //获取标题行
				Map<Integer,Object> titleMap = new HashMap<Integer, Object>();
				for (int i = 0; i < coloumNum; i++) {//循环添加标题行
					String titleName = getValue(rowFirst.getCell(i)).replace(" ", "");//循环得到第一行的标题列每个单元格名称
					if(!StringUtils.isEmpty(titleName)){
						titleMap.put(i,titleName);
						//titleList.add(titleMap);
					}
				}
				
				for(int rowNum=1;rowNum<=rows;rowNum++){//循环每一行
					Map<String,Object> listMap = new HashMap<String, Object>();
					XSSFRow row=sheet.getRow(rowNum); //取到当前行
					for (int i = 0; i < coloumNum; i++) {//循环每一行的每一列
						String name = "";
						try {
							name=getValue(row.getCell(i));//.replace(" ", "");
						} catch (Exception e) {
							// TODO: handle exception
						}
						String titleName = titleMap.get(i)+"";
						if(!StringUtils.isEmpty(name)){
							listMap.put(EngName.get(titleName)+"", name);
						}else{
							listMap.put(EngName.get(titleName)+"", null);
						}
						
					}
					listMap.put("rowNum", rowNum);//存储当前行数
					resultList.add(listMap);
				}
			}
			return resultList;
		}
		
		/*
		 * 	readXlsx 读取xls格式
		 * */
		public static List<Map> readXls(InputStream is,Map EngName) throws Exception{
			//SimpleDateFormat time = new SimpleDateFormat("yyyy-MM-dd");
			List<Map> titleList = new ArrayList<Map>();//标题行的list
			List<Map> resultList = new ArrayList();//最终的list
			
			HSSFWorkbook wb=new HSSFWorkbook(is); //获取整个Excel文档
			for(int numSheet=0;numSheet<wb.getNumberOfSheets();numSheet++){//循环sheet
				HSSFSheet sheet=wb.getSheetAt(numSheet);//这里表示当前页的数据
				if(sheet==null)
					continue; //如果当前页面没有数据则跳出循环 继续下一页
				//获取当前页的行数
				int rows=sheet.getLastRowNum();
				//当前sheet的列数
				int coloumNum = 0;
				if(rows!=0){
					coloumNum=sheet.getRow(0).getPhysicalNumberOfCells();
				}
				if(rows==0 && coloumNum==0){
					continue;
				}
				HSSFRow rowFirst=sheet.getRow(0); //获取标题行
				Map<Integer,Object> titleMap = new HashMap<Integer, Object>();
				for (int i = 0; i < coloumNum; i++) {//循环添加标题行
					String titleName = getValue(rowFirst.getCell(i)).replace(" ", "");//循环得到第一行的标题列每个单元格名称
					if(!StringUtils.isEmpty(titleName)){
						titleMap.put(i,titleName);
						//titleList.add(titleMap);
					}
				}
				
				for(int rowNum=1;rowNum<=rows;rowNum++){//循环每一行
					Map<String,Object> listMap = new HashMap<String, Object>();
					HSSFRow row=sheet.getRow(rowNum); //取到当前行
					for (int i = 0; i < coloumNum; i++) {//循环每一行的每一列
						String name = "";
						try {
							name=getValue(row.getCell(i));//.replace(" ", "");
						} catch (Exception e) {
							// TODO: handle exception
						}
						String titleName = titleMap.get(i)+"";
						if(!StringUtils.isEmpty(name)){
							String EngNameVal = EngName.get(titleName)+"";
							if(!StringUtils.isEmpty(EngNameVal) && !EngNameVal.equals("null")){
								listMap.put(EngNameVal, name);
							}else{
								listMap.put(titleName, name);
							}
						}else{
							listMap.put(EngName.get(titleName)+"", null);
						}
						
					}
					listMap.put("rowNum", rowNum);//存储当前行数
					resultList.add(listMap);
				}
			}
			return resultList;
		}
		
		/**
	     * 
	     * 转换单元格的类型为String 默认的 <br>
	     * 默认的数据类型：CELL_TYPE_BLANK(3), CELL_TYPE_BOOLEAN(4),
	     * CELL_TYPE_ERROR(5),CELL_TYPE_FORMULA(2), CELL_TYPE_NUMERIC(0),
	     * CELL_TYPE_STRING(1)
	     * 
	     * @param cell
	     * @return
	     * 
	     */
	    private static String getValue(Cell cell){
	        String strCell = "";
	        if (cell == null) {
	            return null;
	        }
	        if(cell.getCellTypeEnum()==CellType.BOOLEAN){
	        	strCell = String.valueOf(cell.getBooleanCellValue());
	        }else if(cell.getCellTypeEnum()==CellType.NUMERIC){
	        	if (HSSFDateUtil.isCellDateFormatted(cell)) {
	                Date date = cell.getDateCellValue();
	                strCell=CalendarUntil.ToDateString(date);
	            }else{
	            	// 不是日期格式，则防止当数字过长时以科学计数法显示
		            cell.setCellType(CellType.STRING);
		            strCell = cell.toString();
	            }
	        }else{
	        	strCell = cell.getStringCellValue();
	        }
	        return strCell;
	    }
}
