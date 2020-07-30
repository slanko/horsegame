﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class openMenu : MonoBehaviour
{
    public GameObject diary;
    public KeyCode menuKey;
    bool menuUp;
    // Start is called before the first frame update
    void Start()
    {
        diary.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(menuKey))
        {
            if(diary.activeSelf == true)
            {
                diary.SetActive(false);
                Cursor.lockState = CursorLockMode.Locked;
                Cursor.visible = false;
            }
            else
            {
                diary.SetActive(true);
                Cursor.lockState = CursorLockMode.None;
                Cursor.visible = true;
            }
        }   
    }
}