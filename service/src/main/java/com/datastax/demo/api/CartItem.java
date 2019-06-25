package com.datastax.demo.api;

import com.datastax.oss.driver.api.core.cql.Row;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.time.Instant;

public class CartItem {
    private int id;
    private String name;
    private Instant dateAdded;

    public CartItem(Row row) {
        this.id = row.getInt("item_id");
        this.name = row.getString("item_name");
        this.dateAdded = row.getInstant("date_added");
    }

    @JsonCreator
    public CartItem(@JsonProperty("id") int id, @JsonProperty("name") String name) {
        this.id = id;
        this.name = name;
    }

    @JsonProperty("id")
    public int getId() {
        return id;
    }

    @JsonProperty("name")
    public String getName() {
        return name;
    }

    @JsonProperty("date_added")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss.SSS", timezone = "UTC")
    public Instant getDateAdded() {
        return dateAdded;
    }
}
