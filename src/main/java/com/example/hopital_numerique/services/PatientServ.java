package com.example.hopital_numerique.services;

import com.example.hopital_numerique.dao.daoInterfaces.*;
import com.example.hopital_numerique.dao.daoInterfaces.Ipatient;

import com.example.hopital_numerique.model.*;
import com.example.hopital_numerique.services.serviceIntefaces.ISpatien;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public class PatientServ implements ISpatien {

    Idoctor doctorDao;
    Iroom roomDao;
    Iconsultation consultationDao;
    Ipatient patientDao;

    public PatientServ(Iconsultation consultationDao , Idoctor doctorDao , Iroom roomDao , Ipatient patientDao) {
        this.roomDao = roomDao;
        this.doctorDao = doctorDao;
        this.consultationDao = consultationDao;
        this.patientDao = patientDao;

    }

    @Override
    public Patient addPatient(Patient patient) {
        if(patient.getHeight() == 0 || patient.getWeight()== 0) {
            throw new IllegalArgumentException("Height and Weight cannot be zero");
        }
        patientDao.save(patient);
        return patient;

    }

    @Override
    public boolean isRoomAvailable(Consultation consultation) {
        Room roomById = roomDao.findById(consultation.getRoom().getId());
        if (roomById == null) {
            throw new IllegalArgumentException("Room not found");
        }

        return isAvailable(consultation, roomById.getConsultation());
    }

    public boolean isDoctorAvailable(Consultation consultation) {
        Doctor doctorById = doctorDao.findById(consultation.getDoctor().getId());
        if (doctorById == null) {
            throw new IllegalArgumentException("Doctor not found");
        }

        return isAvailable(consultation, doctorById.getConsultations());
    }

    @Override
    public boolean isAvailable(Consultation consultation, List<Consultation> consultations) {
        LocalTime time = consultation.getDate().atTime(consultation.getHour()).toLocalTime();
        int minute = time.getMinute();
        LocalTime startTime = LocalTime.of(9, 0);
        LocalTime endTime = LocalTime.of(18, 30);

        if (minute != 0 && minute != 30) {
            throw new IllegalArgumentException("Consultation time must be on the hour or half-hour");
        }

        if (time.isBefore(startTime) || time.isAfter(endTime)) {
            throw new IllegalArgumentException("Consultation time must be between 9:00 and 18:30");
        }

        return consultations.stream().noneMatch(c -> c.getDate().equals(consultation.getDate()));
    }



    @Override
    public Consultation bookAppointment(Patient patient, Doctor doctor, Consultation consultation, Room room , LocalDate date, LocalTime hour ) {
        if(patient == null || doctor == null || consultation == null) {
            throw new IllegalArgumentException("Patient, Doctor and Consultation cannot be null");
        }
        if(!isRoomAvailable(consultation)) {
            throw new IllegalArgumentException("Room is not available");
        }
        if(!isDoctorAvailable(consultation)) {
            throw new IllegalArgumentException("Doctor is not available");
        }
        consultation.setPatient(patient);
        consultation.setStatus(Status.PENDING);
        consultation.setRoom(room);
        consultation.setDate(date);
        consultation.setHour(hour);
        consultationDao.save(consultation);
        return consultation;
    }

    @Override
    public void cancelAppointment(Patient patient, Consultation consultation) {
        if(patient == null || consultation == null) {
            throw new IllegalArgumentException("Patient and Consultation cannot be null");
        }
        if(!consultation.getPatient().equals(patient)) {
            throw new IllegalArgumentException("Patient is not assigned to this consultation");
        }
        consultation.setStatus(Status.CANCELED);
        consultationDao.update(consultation);

    }

    @Override
    public Consultation modifyAppointment(Patient patient, Consultation consultation , Room room , LocalDate date, LocalTime hour) {
        if(patient == null || consultation == null) {
            throw new IllegalArgumentException("Patient and Consultation cannot be null");
        }
        if(!consultation.getPatient().equals(patient)) {
            throw new IllegalArgumentException("Patient is not assigned to this consultation");
        }
        if(!isRoomAvailable(consultation)) {
            throw new IllegalArgumentException("Room is not available");
        }
        if(!isDoctorAvailable(consultation)) {
            throw new IllegalArgumentException("Doctor is not available");
        }
        consultationDao.update(consultation);
        return consultation;
    }

    @Override
    public List<Consultation> getConsultationHistory(Patient patient) {
        if(patient == null) {
            throw new IllegalArgumentException("Patient cannot be null");
        }
        return consultationDao.findAll().stream().filter(consultation -> consultation.getPatient().equals(patient)).toList();
    }





}
