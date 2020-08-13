using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class treeScript : MonoBehaviour
{
    public string myName;
    public GameObject myItem, dropPoint;

    public void dropIt()
    {
        var droppedItem = Instantiate(myItem, dropPoint.transform.position, dropPoint.transform.rotation);
        droppedItem.GetComponent<Rigidbody>().AddForce(new Vector3(Random.Range(-1f, 1f), 10, Random.Range(-1f, 1f)), ForceMode.Impulse);
    }
}
