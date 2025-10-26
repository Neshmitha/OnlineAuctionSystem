package com.onlineauction.model;

import java.sql.Timestamp;

public class Item {
    private int id;
    private String name;
    private String description;
    private double basePrice;
    private double currentBid;
    private Integer highestBidder;
    private Timestamp bidStartTime;
    private Timestamp bidEndTime;
    private String image;

    public Item() {
    }

    public Item(int id, String name, String description, double basePrice, double currentBid,
                Integer highestBidder, Timestamp bidStartTime, Timestamp bidEndTime, String image) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.basePrice = basePrice;
        this.currentBid = currentBid;
        this.highestBidder = highestBidder;
        this.bidStartTime = bidStartTime;
        this.bidEndTime = bidEndTime;
        this.image = image;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(double basePrice) {
        this.basePrice = basePrice;
    }

    public double getCurrentBid() {
        return currentBid;
    }

    public void setCurrentBid(double currentBid) {
        this.currentBid = currentBid;
    }

    public Integer getHighestBidder() {
        return highestBidder;
    }

    public void setHighestBidder(Integer highestBidder) {
        this.highestBidder = highestBidder;
    }

    public Timestamp getBidStartTime() {
        return bidStartTime;
    }

    public void setBidStartTime(Timestamp bidStartTime) {
        this.bidStartTime = bidStartTime;
    }

    public Timestamp getBidEndTime() {
        return bidEndTime;
    }

    public void setBidEndTime(Timestamp bidEndTime) {
        this.bidEndTime = bidEndTime;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getStatus() {
        long now = System.currentTimeMillis();
        long start = bidStartTime.getTime();
        long end = bidEndTime.getTime();

        if (now < start) {
            return "Not Started";
        } else if (now >= start && now <= end) {
            return "Active";
        } else {
            return "Closed";
        }
    }
}
