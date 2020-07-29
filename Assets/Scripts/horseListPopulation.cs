using System.Collections;
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
            child.GetComponentInChildren<Image>().sprite = theList.masterHorseList[i].smallPicture;
            i++;
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
