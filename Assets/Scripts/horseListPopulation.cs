using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class horseListPopulation : MonoBehaviour
{
    public horseListScript theList;
    public GameObject horseListUI, horseListEntry;
    public Sprite bigImage;

    // Start is called before the first frame update
    void Start()
    {
        populateList();
    }


    public void populateList()
    {
        for(int yahoo = 0; yahoo < theList.masterHorseList.Length; yahoo++)
        {
            var entryJustAdded = Instantiate(horseListEntry);
            theList.masterHorseList[yahoo].horseName = theList.masterHorseList[yahoo].prefab.GetComponent<horseBehaviour>().horseName;
            theList.masterHorseList[yahoo].logged = true;
            entryJustAdded.transform.SetParent(this.gameObject.transform);
            entryJustAdded.transform.localScale = new Vector3(1, 1, 1);
        }

        int i = 0;
        foreach (Transform child in transform)
        {
            if(PlayerPrefs.GetInt("horse" + i) == 1)
            {
                theList.masterHorseList[i].logged = true;
            }
            if(theList.masterHorseList[i].logged == true)
            {
                child.name = i.ToString();
                child.transform.Find("Image").GetComponent<Image>().sprite = theList.masterHorseList[i].smallPicture;
            }
            else
            {
                child.name = "mystery horse....";
                child.transform.Find("Image").GetComponent<Image>().sprite = bigImage;
            }
            i++;
        }
    }
}
