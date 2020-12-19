﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class mainmenuScript : MonoBehaviour
{
    [SerializeField] GameObject tutorialButton;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(PlayerPrefs.GetFloat("tutorialComplete") == 1f)
        {
            tutorialButton.SetActive(true);
        }
    }

    public void startButtonPushed()
    {
        if(PlayerPrefs.GetFloat("tutorialComplete") != 1f)
        {
            SceneManager.LoadScene("tutorialscene");
        }
        if(PlayerPrefs.GetFloat("tutorialComplete") == 1f)
        {
            SceneManager.LoadScene("SampleScene");
        }
    }

    public void tutorialButtonPushed()
    {
        SceneManager.LoadScene("tutorialscene");
    }
}


//don't make me lal