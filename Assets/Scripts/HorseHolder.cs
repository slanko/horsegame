using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HorseHolder : MonoBehaviour
{

    [SerializeField] GameObject[] horsePrefabs;




    public List<horseBehaviour> horseList = new List<horseBehaviour>();

    public void AddHorse(horseBehaviour _hb)
    {
        bool horseExists = false;

        foreach (horseBehaviour hb in horseList)
        {
            if(_hb.name == hb.name)
            {
                horseExists = true;
            }
        }

        if (!horseExists)
        {
            horseBehaviour hnew = new horseBehaviour();
            hnew.name = _hb.name;
            horseList.Add(hnew);
        }
    }


    public void InstantiateHorse(int horseIWant)
    {

    }


}
