using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class onClickChangeButton : MonoBehaviour
{

    horseListScript theList;
    Text horseListUIText, horseListUIName;
    Image horseListUIImage;

    // Start is called before the first frame update
    void Start()
    {
        theList = GameObject.Find("GOD").GetComponent<horseListScript>();
        horseListUIText = GameObject.Find("Diary/Descriptor/Description").GetComponent<Text>();
        horseListUIName = GameObject.Find("Diary/Descriptor/Name").GetComponent<Text>();
        horseListUIImage = GameObject.Find("Diary/Descriptor/Horse portrait").GetComponent<Image>();
    }

    public void changeTheStuff()
    {
        int myNumber = int.Parse(gameObject.name);
        theList.currentHorseSelected = myNumber;
        horseListUIName.text = theList.masterHorseList[myNumber].horseName;
        horseListUIText.text = theList.masterHorseList[myNumber].description;
        horseListUIImage.sprite = theList.masterHorseList[myNumber].bigPicture;
    }
}
