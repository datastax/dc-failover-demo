package com.datastax.demo.api;

import com.fasterxml.jackson.annotation.JsonProperty;

public class DemoEntity {
    private int id;

    private String content;

    public DemoEntity() {
        // Jackson deserialization
    }

    public DemoEntity(int id, String content) {
        this.id = id;
        this.content = content;
    }

    @JsonProperty
    public int getId() {
        return id;
    }

    @JsonProperty
    public String getContent() {
        return content;
    }

    @Override
    public String toString() {
        return "DemoEntity{" + "id=" + id + ", content='" + content + '\'' + '}';
    }
}
