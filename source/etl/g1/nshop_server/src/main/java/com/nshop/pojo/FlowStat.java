package com.nshop.pojo;

public class FlowStat {
    private int customer_genger;
        private String age_ranger;
    private String customer_natives;
    private int visit_avg_duration;
    private int visit_avg_counts;
    private String bdp_day;

    public int getCustomer_genger() {
        return customer_genger;
    }

    public void setCustomer_genger(int customer_genger) {
        this.customer_genger = customer_genger;
    }

    public String getAge_ranger() {
        return age_ranger;
    }

    public void setAge_ranger(String age_ranger) {
        this.age_ranger = age_ranger;
    }

    public String getCustomer_natives() {
        return customer_natives;
    }

    public void setCustomer_natives(String customer_natives) {
        this.customer_natives = customer_natives;
    }

    public int getVisit_avg_duration() {
        return visit_avg_duration;
    }

    public void setVisit_avg_duration(int visit_avg_duration) {
        this.visit_avg_duration = visit_avg_duration;
    }

    public int getVisit_avg_counts() {
        return visit_avg_counts;
    }

    public void setVisit_avg_counts(int visit_avg_counts) {
        this.visit_avg_counts = visit_avg_counts;
    }

    public String getBdp_day() {
        return bdp_day;
    }

    public void setBdp_day(String bdp_day) {
        this.bdp_day = bdp_day;
    }

    @Override
    public String toString() {
        return "FlowStat{" +
                "customer_genger=" + customer_genger +
                ", age_ranger='" + age_ranger + '\'' +
                ", customer_natives='" + customer_natives + '\'' +
                ", visit_avg_duration=" + visit_avg_duration +
                ", visit_avg_counts=" + visit_avg_counts +
                ", bdp_day='" + bdp_day + '\'' +
                '}';
    }
}
