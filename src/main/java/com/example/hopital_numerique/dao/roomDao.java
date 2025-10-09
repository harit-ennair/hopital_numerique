package com.example.hopital_numerique.dao;

import com.example.hopital_numerique.dao.daoInterfaces.Iroom;
import com.example.hopital_numerique.model.Room;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.time.LocalDate;
import java.util.List;

public class roomDao implements Iroom {
    @Override
    public void save(Room room) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(room);
        em.getTransaction().commit();
        em.close();
        emf.close();
    }

    @Override
    public void update(Room room) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.merge(room);
        em.getTransaction().commit();
        em.close();
        emf.close();
    }

    @Override
    public void delete(int roomId) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        Room room = em.find(Room.class, roomId);
        if (room != null) {
            em.getTransaction().begin();
            em.remove(room);
            em.getTransaction().commit();
        }
        em.close();
        emf.close();
    }

    @Override
    public Room findById(int roomId) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        Room room = em.find(Room.class, roomId);
        em.close();
        emf.close();
        return room;
    }

    @Override
    public Room findByName(String name) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        Room room = em.createQuery("SELECT r FROM Room r WHERE r.name = :name", Room.class)
                .setParameter("name", name)
                .getSingleResult();
        em.close();
        emf.close();
        return room;
    }

    @Override
    public List<Room> findAll() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        List<Room> rooms = em.createQuery("SELECT r FROM Room r", Room.class).getResultList();
        em.close();
        emf.close();
        return rooms;
    }

    @Override
    public List<Room> findByCapacity(int capacity) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        List<Room> rooms = em.createQuery("SELECT r FROM Room r WHERE r.capacity = :capacity", Room.class)
                .setParameter("capacity", capacity)
                .getResultList();
        em.close();
        emf.close();
        return rooms;
    }

    @Override
    public List<Room> findAvailableRooms(LocalDate date) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        List<Room> rooms = em.createQuery("SELECT r FROM Room r WHERE r.id NOT IN " +
                        "(SELECT c.room.id FROM Consultation c WHERE c.date = :date)", Room.class)
                .setParameter("date", date)
                .getResultList();
        em.close();
        emf.close();
        return rooms;
    }

    @Override
    public List<Room> findByCapacityGreaterThan(int minCapacity) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        List<Room> rooms = em.createQuery("SELECT r FROM Room r WHERE r.capacity > :minCapacity", Room.class)
                .setParameter("minCapacity", minCapacity)
                .getResultList();
        em.close();
        emf.close();
        return rooms;
    }
}
