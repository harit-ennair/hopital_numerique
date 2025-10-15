package com.example.hopital_numerique.controller;

import com.example.hopital_numerique.controller.controllerInterfaces.ICadmen;
import com.example.hopital_numerique.dao.*;
import com.example.hopital_numerique.services.AdmenServ;
import com.example.hopital_numerique.services.DoctorServ;
import com.example.hopital_numerique.services.PatientServ;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;


    @WebServlet
    public class AdmenCont extends HttpServlet implements ICadmen {

        private AdmenServ admenService;
        private PatientServ patientService;
        private DoctorServ doctorService;
        private PatientDao patientDao;
        private DoctorDao doctorDao;



        @Override
        public void init() throws ServletException {
            this.patientDao = new PatientDao();
            this.doctorDao = new DoctorDao();
            this.patientService = new PatientServ(
                    new ConsulltationDao(),
                    doctorDao,
                    new RoomDao(),
                    patientDao);
        }
    }

