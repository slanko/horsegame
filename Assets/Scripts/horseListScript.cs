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
    [Multiline(4)]
    public string description;
    public Sprite bigPicture, smallPicture;
}
public class horseListScript : MonoBehaviour
{
    public horseStruct[] masterHorseList;
    godScript GOD;
    public bool horseDetected;
    horseBehaviour hB;
    public horseListPopulation hLP;
    public int currentHorseSelected = 0;
    public GameObject currentPipe;

    // Start is called before the first frame update
    void Start()
    {
        GOD = GameObject.Find("GOD").GetComponent<godScript>();
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
        hLP.populateList();
    }

    public void summonHorse()
    {
        var newHorse = Instantiate(masterHorseList[currentHorseSelected].prefab, currentPipe.transform.position, new Quaternion(0, 0, 0, 0));
        newHorse.GetComponent<horseBehaviour>().isTamed = true;
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
