package com.nshop.controller;

import com.nshop.pojo.FlowStat;
import com.nshop.pojo.Result;
import com.nshop.service.NshopService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
public class NshopController {

    @Autowired
    private NshopService nshopService;

    @RequestMapping("/findFlows")
    public Result findFlows(){
        Result result=null;
        try {
            List<FlowStat> data = nshopService.findFlows();
            if(data!=null ){
                 result = Result.getresult(200, "查询成功", data);

            }
        } catch (Exception e) {
            e.printStackTrace();
             result = Result.getresult(500, "查询失败", null);

        }
        return result;
    }

    @RequestMapping("/findFlowup")
    public Result findFlowup(){
        Result result=null;
        try {
            List<Map<String,String>> data = nshopService.findFlowup();
            if(data!=null ){
                result = Result.getresult(200, "查询成功", data);

            }
        } catch (Exception e) {
            e.printStackTrace();
            result = Result.getresult(500, "查询失败", null);

        }
        return result;
    }
}
