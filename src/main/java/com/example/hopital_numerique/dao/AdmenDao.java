package com.example.hopital_numerique.dao;

import com.example.hopital_numerique.dao.daoInterfaces.Iadmen;
import com.example.hopital_numerique.model.Admen;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.util.List;

public class AdmenDao implements Iadmen {
    @Override
    public void save(Admen admen) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(admen);
        em.getTransaction().commit();
        em.close();
        emf.close();

    }

    @Override
    public void update(Admen admen) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.merge(admen);
        em.getTransaction().commit();
        em.close();
        emf.close();

    }

    @Override
    public void delete(int admenId) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        Admen admen = em.find(Admen.class, admenId);
        if (admen != null) {
            em.getTransaction().begin();
            em.remove(admen);
            em.getTransaction().commit();
        }
        em.close();
        emf.close();

    }

    @Override
    public Admen findById(int admenId) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        Admen admen = em.find(Admen.class, admenId);
        em.close();
        emf.close();
        return admen;
    }

    @Override
    public List<Admen> findAll() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        List<Admen> admens = em.createQuery("SELECT a FROM Admen a", Admen.class).getResultList();
        em.close();
        emf.close();
        return admens;
    }
}
