package com.nshop.pojo;

public class Result {
    private int code;
    private String message;
    private Object data;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    public static Result getresult(int code,String message,Object data){
        Result result = new Result();
        result.setCode(code);
        result.setMessage(message);
        result.setData(data);
        return result;
    }
}
