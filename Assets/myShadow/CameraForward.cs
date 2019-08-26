using UnityEngine;
using System.Collections;

public class CameraForward : MonoBehaviour
{

	// Use this for initialization
	public Transform cameraTrans;
	private Quaternion initRotation;

	void Start ()
	{
		if (cameraTrans == null) {
			cameraTrans = Camera.main.transform;
		}
	}
	
	// Update is called once per frame
	void Update ()
	{
		transform.rotation = Quaternion.RotateTowards (cameraTrans.rotation, initRotation, Mathf.Infinity);
	}
}
