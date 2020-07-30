using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class onClickChangeButton : MonoBehaviour
{

    horseListScript theList;
    Text horseListUIText;
    Image horseListUIImage;

    // Start is called before the first frame update
    void Start()
    {
        theList = GameObject.Find("GOD").GetComponent<horseListScript>();
        horseListUIText = GameObject.Find("Diary/Descriptor/Text").GetComponent<Text>();
        horseListUIImage = GameObject.Find("Diary/Descriptor/Horse portrait").GetComponent<Image>();
    }

    public void changeTheStuff()
    {
        int myNumber = int.Parse(gameObject.name);
        horseListUIText.text = theList.masterHorseList[myNumber].description;
        horseListUIImage.sprite = theList.masterHorseList[myNumber].bigPicture;
    }
}
