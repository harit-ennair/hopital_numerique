package com.example.hopital_numerique.dao.daoInterfaces;

import com.example.hopital_numerique.model.Room;
import java.time.LocalDate;
import java.util.List;

public interface Iroom {
    void save(Room room);
    void update(Room room);
    void delete(int roomId);
    Room findById(int roomId);
    Room findByName(String name);
    List<Room> findAll();
    List<Room> findByCapacity(int capacity);
    List<Room> findAvailableRooms(LocalDate date);
    List<Room> findByCapacityGreaterThan(int minCapacity);
}
