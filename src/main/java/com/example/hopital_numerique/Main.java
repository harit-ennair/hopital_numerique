package com.example.hopital_numerique;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;


public class Main {

    public static void main(String[] args) {


        try (EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit")) {
            EntityManager em = emf.createEntityManager();
            em.getTransaction().begin();

            em.getTransaction().commit();
            em.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}