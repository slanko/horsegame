using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class treeScript : MonoBehaviour
{
    public string myName;
    public GameObject myItem;
    public GameObject[] dropPoints;
    int numberOfTimesInteracted;
    private void Start()
    {
        myName = myItem.GetComponent<throwablesScript>().myName + " tree";
        foreach(GameObject droppo in dropPoints)
        {
            var myFruit = Instantiate(myItem, droppo.transform.position, droppo.transform.rotation);
            myFruit.GetComponent<Rigidbody>().constraints = RigidbodyConstraints.FreezeAll;
        }
    }

    public void dropIt()
    {
        var dropPoint = dropPoints[numberOfTimesInteracted];
        var droppedItem = Instantiate(myItem, dropPoint.transform.position, dropPoint.transform.rotation);
        droppedItem.GetComponent<Rigidbody>().AddForce(new Vector3(Random.Range(-1f, 1f), 10, Random.Range(-1f, 1f)), ForceMode.Impulse);
    }
}
