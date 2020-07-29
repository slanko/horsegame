using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
[System.Serializable]
public struct horseStruct
{
    public string horseName;
    public GameObject prefab;
    public bool logged;
    public string description;
    public Sprite bigPicture, smallPicture;
}
public class horseListScript : MonoBehaviour
{
    public horseStruct[] masterHorseList;
    godScript GOD;
    bool horseDetected;
    horseBehaviour hB;
    // Start is called before the first frame update
    void Start()
    {
        GOD = GameObject.Find("GOD").GetComponent<godScript>();
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Q))
        {
            AddToHorseList();
        }
    }

    public void AddToHorseList()
    {
        if(horseDetected == true)
        {
            bool itsME = false;
            for(int i = 0; i < masterHorseList.Length; i++)
            {
                horseStruct horsey = masterHorseList[i];
                if(horsey.horseName == hB.horseName)
                {
                    itsME = true;
                    masterHorseList[i].logged = true;
                }
            }
            if(itsME == true)
            {

                hB.anim.SetTrigger("whee");
            }
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if(other.gameObject.tag == "horse")
        {
            hB = other.gameObject.GetComponent<horseBehaviour>();
            if(hB.isTamed == true)
            {
                horseDetected = true;
            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "horse")
        {
                horseDetected = false;
        }
    }
}
