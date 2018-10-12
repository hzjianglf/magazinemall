package cn.admin.system.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import cn.admin.system.model.Contract;

@Service
//事务处理
@Transactional(propagation=Propagation.REQUIRED,rollbackFor=Exception.class)
public class ContractService {

	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	
	/**
	 * 查询所有未删除的合同
	 * @return
	 */
	public List<Contract> getContractList(Map<String, Object> map){
		return sqlSession.selectList("contractDao.getContractList", map);
	}
	
	/**
	 * 查询未删除的合同总数
	 * @param map
	 * @return
	 */
	public long getCount(Map<String, Object> map){
		return sqlSession.selectOne("contractDao.getCount", map);
	}
	
	/**
	 * 添加合同
	 * @param contract
	 * @return
	 */
	public int addContract(Contract contract){
		return sqlSession.insert("contractDao.insert", contract);
	}
	
	/**
	 * 查询单个合同信息
	 * @param id
	 * @return
	 */
	public Contract selectContractById(int id){
		return sqlSession.selectOne("contractDao.selectContractById", id);
	}

	/**
	 * 修改合同
	 * @param map
	 * @return
	 */
	public int updateContract(Contract contract){
		return sqlSession.update("contractDao.updateContract", contract);
	}
	
	/**
	 * 选择性修改合同,为null字段不修改
	 * @param contract
	 * @return
	 */
	public int updateContractSelective(Contract contract){
		return sqlSession.update("contractDao.updateContractSelective", contract);
	}
	
	/**
	 * 删除合同，修改合同的删除状态为1
	 * @param id
	 * @return
	 */
	public int deleteContract(int id){
		return sqlSession.update("contractDao.deleteContract", id);
	}
	
	/**
	 * 修改合同的启用禁用状态
	 * @param map
	 * @return
	 */
	public int modifyStatus(Map<String, Object> map){
		return sqlSession.update("contractDao.modifyStatus", map);
	}

}

