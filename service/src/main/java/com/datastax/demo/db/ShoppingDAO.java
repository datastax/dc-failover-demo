package com.datastax.demo.db;

import com.datastax.demo.api.CartItem;
import com.datastax.oss.driver.api.core.ConsistencyLevel;
import com.datastax.oss.driver.api.core.CqlSession;
import com.datastax.oss.driver.api.core.DefaultConsistencyLevel;
import com.datastax.oss.driver.api.core.cql.PreparedStatement;
import com.datastax.oss.driver.api.core.cql.ResultSet;
import com.datastax.oss.driver.api.core.cql.Row;

import java.util.ArrayList;
import java.util.List;

public class ShoppingDAO
{
    private final CqlSession session;

    private final PreparedStatement selectCart;
    private final PreparedStatement insertItemIntoCart;

    private static final ConsistencyLevel READ_CONSISTENCY_LEVEL = DefaultConsistencyLevel.LOCAL_QUORUM;
    private static final ConsistencyLevel WRITE_CONSISTENCY_LEVEL = DefaultConsistencyLevel.LOCAL_QUORUM;

    public ShoppingDAO(CqlSession session) {
        this.session = session;

        this.selectCart = session.prepare("SELECT * FROM shopping.carts WHERE username = ?");
        this.insertItemIntoCart = session.prepare("INSERT INTO shopping.carts (username, item_id, date_added, item_name) VALUES (?, ?, toTimestamp(now()), ?)");
    }

    public Iterable<CartItem> getCart(String username) {
        ResultSet rs = session.execute(selectCart
                .bind(username)
                .setConsistencyLevel(READ_CONSISTENCY_LEVEL));
        List<CartItem> items = new ArrayList<>(rs.getAvailableWithoutFetching());
        for (Row row : rs) {
            items.add(new CartItem(row));
        }
        return items;
    }

    public void addItem(String username, CartItem item) {
        session.execute(insertItemIntoCart
                .bind(username, item.getId(), item.getName())
                .setConsistencyLevel(WRITE_CONSISTENCY_LEVEL));
    }
}
