package com.nshop.service.impl;

import com.nshop.mapper.NshopMapper;
import com.nshop.pojo.FlowStat;
import com.nshop.service.NshopService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;


@Service
public class NshopServiceImpl implements NshopService {

    @Autowired
    private NshopMapper nshopMapper;
    @Override
    public List<FlowStat> findFlows() {
        return nshopMapper.findFlows();
    }

    @Override
    public List<Map<String,String>> findFlowup() {
        return nshopMapper.findFlowup();
    }
}
