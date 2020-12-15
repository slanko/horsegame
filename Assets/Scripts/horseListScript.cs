using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using GameAnalyticsSDK;
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
    public bool horseDetected;
    horseBehaviour hB;
    public horseListPopulation hLP;
    public int currentHorseSelected = 0;
    public GameObject currentPipe;
    godScript GOD;
    [SerializeField] GameObject[] stableHorses;
    [SerializeField] GameObject playerObject;


    private void Start()
    {
        GOD = GameObject.Find("GOD").GetComponent<godScript>();
        GameAnalytics.Initialize();
    }

    public void AddToHorseList()
    {
        if(horseDetected == true)
        {
            if(hB.horseName == "FISHMIN")
            {
                notAHorse();
            }
            bool itsME = false;
            for(int i = 0; i < masterHorseList.Length; i++)
            {
                horseStruct horsey = masterHorseList[i];
                if(horsey.horseName == hB.horseName)
                {
                    itsME = true;
                    masterHorseList[i].logged = true;
                    PlayerPrefs.SetInt("horse" + i, 1);
                    Debug.Log("horse" + i + " = " + PlayerPrefs.GetInt("horse" + i));
                    GameAnalytics.NewDesignEvent("HorseCollected: " + horsey.horseName);
                }
            }
            if(itsME == true)
            {
                if(GOD.tutorialTime == true)
                {
                    GOD.tBz.setSeventhBool();
                }
                hB.anim.SetTrigger("whee");
            }
        }
        hLP.populateList(false);
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

                if(GOD.tutorialTime == true)
                {
                    GOD.tBz.setSixthBool();
                }
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

    private void notAHorse()
    {
        //get current stable horse. set it's text to "that's not a horse..."
        //lol we could just get the closest one
        //yea
        float shortestDistance = Mathf.Infinity, dist;
        GameObject selectedStablehorse = new GameObject();
        foreach (GameObject horse in stableHorses)
        {
            dist = Vector3.Distance(playerObject.transform.position, horse.transform.position);
            if (dist < shortestDistance)
            {
                shortestDistance = dist;
                selectedStablehorse = horse;
            }
        }
        selectedStablehorse.GetComponent<stableHorseScript>().setMyText("that's not a horse...");
    }
}
