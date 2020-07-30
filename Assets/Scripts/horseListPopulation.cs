﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class horseListPopulation : MonoBehaviour
{
    public horseListScript theList;
    public GameObject horseListUI;

    // Start is called before the first frame update
    void Start()
    {
        int i = 0;
        foreach(Transform child in transform)
        {
            child.name = i.ToString();
            child.transform.Find("Image").GetComponent<Image>().sprite = theList.masterHorseList[i].smallPicture;
            i++;
        }
    }
}