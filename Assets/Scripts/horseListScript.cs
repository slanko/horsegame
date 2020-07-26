using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class horseListScript : MonoBehaviour
{

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
            GOD.horseList.Add(hB.myPrefab);
            hB.anim.SetTrigger("whee");
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
